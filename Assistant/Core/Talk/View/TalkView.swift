//
//  TalkView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 13/11/2023.
//

import SwiftUI
import TipKit

struct TalkView: View {
    @ObservedObject var viewModel: TalkViewModel
    let addConversationTip = StartFirstConversation()
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                List(viewModel.messages) { message in
                    messageView(for: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { newValue in
                            scrollToBottom(scrollView: scrollView)
                        }
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .listStyle(.plain)
            }
            TipView(addConversationTip)
                .padding(.horizontal)
            Button {
                if viewModel.isRecording {
                    viewModel.stopRecording()
                } else {
                    viewModel.startRecording()
                }
            } label: {
                Image(systemName: viewModel.isRecording ? "stop.circle" : "mic.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(viewModel.isRecording ? Color(uiColor: .systemRed) : Color(uiColor: .systemBlue))
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding()
        }
        .navigationTitle(viewModel.chat?.topic ?? "Speaking to Assistant")
        .onAppear {
            viewModel.fetchData()
        }
    }
    
    func scrollToBottom(scrollView: ScrollViewProxy) {
        guard !viewModel.messages.isEmpty, let lastMessage = viewModel.messages.last else { return }
        
        withAnimation {
            scrollView.scrollTo(lastMessage.id)
        }
    }
    
    func messageView(for message: AppMessage) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(message.role == .user ? .blue : .white)
                .foregroundStyle(message.role == .user ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

//#Preview {
//    TalkView(viewModel: .init(chatId: "1"), namespace: "circleImage")
//        .task {
//            try? Tips.configure([
//                .displayFrequency(.monthly),
//                .datastoreLocation(.applicationDefault)
//            ])
//        }
//}
