//
//  ChatViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import Foundation
import OpenAI
import FirebaseFirestoreSwift
import FirebaseFirestore
import Speech

@MainActor
class TalkViewModel: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var isRecording = false
    @Published var isGeneratingResponse = false
    
    let chatId: String
    let db = Firestore.firestore()
    
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init(chatId: String) {
        self.chatId = chatId
        requestSpeechAuthorization()
        configureAudioSession() 
    }
    
    // MARK: - Fetch Data
    func fetchData() {
        db.collection("chats").document(chatId).getDocument(as: AppChat.self) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
            case .failure(let failure):
                print(failure)
            }
        }
        
        db.collection("chats").document(chatId).collection("messages").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else { return }
            
            self.messages = documents.compactMap({ snapshot -> AppMessage? in
                do {
                    var message = try snapshot.data(as: AppMessage.self)
                    message.id = snapshot.documentID
                    return message
                } catch {
                    return nil
                }
            })
        }
    }
    
    // MARK: - Voice Function
    
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            if speechSynthesizer.isSpeaking {
                speechSynthesizer.stopSpeaking(at: .immediate)
            }
            startRecording()
        }
    }

    
    func startRecording() {
        isRecording = true
        startListening()
    }
    
    func stopRecording() {
        isRecording = false
        stopListening()
        
        if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task {
                do {
                    try await sendMessage()
                } catch {
                    print("Error sending message: \(error)")
                }
            }
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        speechSynthesizer.speak(utterance)
    }
    
    func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.messageText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try! audioEngine.start()
    }
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func stopSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }

    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
        }
    }
    
    // MARK: - Message
    func sendMessage() async throws {
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText, role: .user)
        
        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error)
        }
        
        await MainActor.run { [newMessage] in
            messages.append(newMessage)
            messageText = ""
        }
        try await generateResponse(for: newMessage)
    }
    
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("chats").document(chatId).collection("messages").addDocument(from: message)
    }
    
    private func generateResponse(for message: AppMessage) async throws {
        isGeneratingResponse = true
        let openAI = OpenAI(apiToken: Constants.apiKey)
        let queryMessages = messages.map { appMessage in
            Chat(role: appMessage.role, content: appMessage.text)
        }
        let query = ChatQuery(model: .gpt4, messages: queryMessages)
        
        var responseParts: [String] = []
        
        for try await result in openAI.chatsStream(query: query) {
            if let newText = result.choices.first?.delta.content {
                responseParts.append(newText)
            }
        }
        
        let fullResponse = responseParts.joined()
        await MainActor.run {
            processFullResponse(fullResponse)
            isGeneratingResponse = false
        }
        
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
        
        isGeneratingResponse = false
    }
    
    func processFullResponse(_ response: String) {
        if !response.isEmpty {
            let newMessage = AppMessage(id: UUID().uuidString, text: response, role: .assistant)
            DispatchQueue.main.async {
                self.messages.append(newMessage)
                self.speak(response)
            }
        }
    }

}

