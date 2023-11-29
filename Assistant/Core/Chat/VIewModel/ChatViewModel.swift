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

class ChatViewModel: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    
    let chatId: String
    let categoryName: String
    
    var currentCategory: ChatBotCategory {
        return ChatBotCategory(rawValue: ChatBotCategory.allCases.firstIndex(where: { $0.title == categoryName }) ?? -1) ?? .booking
    }
    
    var showsDisclaimer: Bool {
        switch ChatBotCategory(rawValue: ChatBotCategory.allCases.firstIndex(where: { $0.title == categoryName }) ?? -1) {
        case .healthAdvice, .financialAdvice, .petCare, .mentalWellbeing:
            return true
        default:
            return false
        }
    }
    
    let db = Firestore.firestore()
    
    init(chatId: String, categoryName: String) {
        self.chatId = chatId
        self.categoryName = categoryName
        
        if let category = ChatBotCategory(rawValue: ChatBotCategory.allCases.firstIndex(where: { $0.title == categoryName }) ?? -1) {
            let initialMessage = AppMessage(text: category.prompt, role: .system)
            self.messages = [initialMessage]
        } else {
            self.messages = []
        }
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
        let openAI = OpenAI(apiToken: Constants.apiKey)
        let queryMessages = messages.map { appMessage in
            Chat(role: appMessage.role, content: appMessage.text)
        }
        let query = ChatQuery(model: .gpt4, messages: queryMessages)
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user {
                    messages[messages.count - 1].text += newText
                } else {
                    let newMessage = AppMessage(id: result.id, text: newText, role: .assistant)
                    messages.append(newMessage)
                }
            }
        }
        
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
    }
}


