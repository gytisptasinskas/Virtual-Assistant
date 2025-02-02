//
//  ChatView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import TipKit

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    

    var body: some View {
        VStack {
            if viewModel.showsDisclaimer {
                TipView(Disclaimer(category: viewModel.currentCategory))
                    .padding()
            }
            ScrollViewReader { scrollView in
                List(viewModel.messages.filter({ $0.role != .system })) { message in
                    MessageView(message: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { _ in
                            scrollView.scrollToBottom(messages: viewModel.messages)
                        }


                }
                .background(Color(uiColor: .systemGroupedBackground))
                .listStyle(.plain)
            }
            messageInputView
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .onAppear {
            viewModel.fetchData()
        }
    }
    
//    func scrollToButtom(scrollView: ScrollViewProxy) {
//        guard !viewModel.messages.isEmpty, let lastMessage = viewModel.messages.last else { return }
//        
//        withAnimation {
//            scrollView.scrollTo(lastMessage.id)
//        }
//    }
    
//    func messageView(for message: AppMessage) -> some View {
//        HStack {
//            if (message.role == .user) {
//                Spacer()
//            }
//            Text(message.text)
//                .padding(.horizontal)
//                .padding(.vertical, 12)
//                .background(message.role == .user ? .blue : .white)
//                .foregroundStyle(message.role == .user ? .white : .black)
//                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//            if (message.role == .assistant) {
//                Spacer()
//            }
//        }
//    }
    
    var messageInputView: some View {
        HStack {
            TextField("Send a message...", text: $viewModel.messageText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit {
                    sendMessage()
                }
            
            Button {
                sendMessage()
            } label: {
                Text("Send")
                    .padding()
                    .background(viewModel.messageText.isEmpty ? Color.gray : Constants.defaultAccentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.messageText.isEmpty)
        }
        .padding()
    }
    
    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ChatView(viewModel: .init(chatId: "1", categoryName: "booking"))
}
