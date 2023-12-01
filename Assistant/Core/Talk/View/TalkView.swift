//
//  TalkView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 13/11/2023.
//

import SwiftUI
import TipKit
import LottieSwiftUI

struct TalkView: View {
    @ObservedObject var viewModel: TalkViewModel
    let addConversationTip = StartFirstConversation()
    
    var body: some View {
        VStack {
            LottieView(name: "voice", play: $viewModel.isRecording)
                .lottieLoopMode(.loop)
                .frame(width: 300, height: 300)
            
            ScrollViewReader { scrollView in
                List(viewModel.messages + (viewModel.isGeneratingResponse ? [AppMessage.placeholder] : [])) { message in
                    if message.isPlaceholder {
                        TypingIndicatorView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id(message.id)
                    } else {
                        messageView(for: message)
                            .id(message.id)
                    }

                }
                .onChange(of: viewModel.messages) { _ in
                    scrollToBottom(scrollView: scrollView)
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .listStyle(.plain)
            }
            TipView(addConversationTip)
                .padding(.horizontal)
            
            Button {
                viewModel.toggleRecording()
            } label: {
                Image(systemName: viewModel.isRecording ? "stop.circle" : "mic.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(viewModel.isRecording ? Color(uiColor: .systemRed) : Constants.defaultAccentColor)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding()
            
        }
        .navigationTitle(viewModel.chat?.topic ?? "Speaking to Assistant")
        .onAppear {
            viewModel.fetchData()
        }
        .onDisappear {
            viewModel.stopSpeech()
        }
    }
    
    func scrollToBottom(scrollView: ScrollViewProxy) {
        if viewModel.isGeneratingResponse {
            withAnimation {
                scrollView.scrollTo("placeholder", anchor: .bottom)
            }
        } else if let lastMessage = viewModel.messages.last {
            withAnimation {
                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
            }
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
