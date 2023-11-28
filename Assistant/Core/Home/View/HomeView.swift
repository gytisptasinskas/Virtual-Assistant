//
//  HomeView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import TipKit

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State private var navigateToChat = false
    @State private var navigateToTalk = false
    @State private var selectedChatId: String? = nil
    @State private var selectedCategoryTitle: String? = nil
    @State private var isDismissed: Bool = true
    @Namespace private var animationNamespace
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                NavigationLink(destination: TalkView(viewModel: .init(chatId: viewModel.newTalkId ?? ""), namespace: animationNamespace), isActive: $navigateToTalk) {
                    EmptyView()
                }
                VStack {
                    Text("Hi \(viewModel.user?.firstName ?? "Welcome")")
                        .font(.headline)
                    
                    Image("circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .matchedGeometryEffect(id: "circleImage", in: animationNamespace)
                        .onTapGesture {
                            Task {
                                await viewModel.createTalk()
                                navigateToTalk = true
                            }
                        }
                    Text("Tap to Chat")
                        .font(.title)
                        .bold()
                }
                .padding(.bottom)
                if isDismissed {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Comming features")
                                    .font(.headline)
                                
                                Spacer()
                                Button {
                                    isDismissed = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .foregroundStyle(Color(uiColor: .label))
                            }
                            Text("Image generation with sharing \nwith your friends")
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                } else {
  
                }

                Text("Explore")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.categories) { category in
                        Button {
                            Task {
                                await viewModel.createChat(for: category)
                                if let chatId = viewModel.newChatId {
                                    selectedChatId = chatId
                                    selectedCategoryTitle = category.title
                                    navigateToChat = true
                                    viewModel.reorderCategories(selectedCategory: category)
                                }
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    category.iconImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(category.color)
                                    
                                    
                                    Text(category.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                              
                                Spacer()
                                
                                Text(category.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 170, height: 170)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .secondarySystemBackground)))
                        }
                    }
                }
                .padding(.horizontal)
                
                NavigationLink(destination: ChatView(viewModel: .init(chatId: viewModel.newChatId ?? "", categoryName: selectedCategoryTitle ?? "")), isActive: $navigateToChat) { EmptyView() }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let user = viewModel.user {
                        Button {
                            viewModel.showProfile()
                        } label: {
                            CircularProfileImageView(user: user, size: .xSmall)
                        }
                    }
                }
            }
            .onAppear {
                if viewModel.loadingState == .none {
                    viewModel.fetchData()
                }
                viewModel.fetchCurrentUser()
            }
        }
        .sheet(isPresented: $viewModel.isShowingProfileView) {
            if let user = viewModel.user {
                ProfileView(user: user)
            }
        }
    }
}
//    @StateObject var viewModel = HomeViewModel()
//    @State private var navigateToChat = false
//    @State private var navigateToTalk = false
//    
//    let historyTip = ConversationList()
//    
//    let columns: [GridItem] = [
//        GridItem(.flexible(), spacing: 20),
//        GridItem(.flexible(), spacing: 20)
//    ]
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
////                NavigationLink(destination: ChatView(viewModel: .init(chatId: viewModel.newChatId ?? "")), isActive: $navigateToChat) { EmptyView() }
//                NavigationLink(destination: TalkView(viewModel: .init(chatId: viewModel.newTalkId ?? "")), isActive: $navigateToTalk) { EmptyView() }
//                
//                Text("How may I help \nyou today?")
//                    .foregroundStyle(Color(uiColor: .label))
//                    .font(.largeTitle)
//                    .fontWeight(.semibold)
//                    .padding(.vertical, 20)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading)
//                
//                HStack {
//                    Spacer()
//                    
//                    Button {
//                        Task {
//                            await viewModel.createTalk()
//                            navigateToTalk = true
//                        }
//                    } label: {
//                        VStack(alignment: .leading ) {
//                            HStack {
//                                Image(systemName: "person.wave.2")
//                                    .padding(8)
//                                    .foregroundStyle(Color(uiColor: .label))
//                                    .background(Color.gray.opacity(0.4))
//                                    .clipShape(Circle())
//                                
//                                Spacer()
//                                Image(systemName: "arrow.up.right")
//                                    .foregroundStyle(Color(uiColor: .label))
//                            }
//                            Spacer()
//                            Text("Talk \nwith Bot")
//                                .multilineTextAlignment(.leading)
//                                .foregroundStyle(Color(uiColor: .label))
//                                .font(.title)
//                                .fontWeight(.semibold)
//                        }
//                        .padding()
//                        .frame(width: 180, height: 210)
//                        .background(Color(uiColor: .systemGreen))
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//                    }
//                    
//                    Spacer()
//                    
//                    Button {
//                        Task {
////                            await viewModel.createChat()
//                            navigateToChat = true
//                        }
//                    } label: {
//                        VStack(alignment: .leading ) {
//                            HStack {
//                                Image(systemName: "bubble.left.and.text.bubble.right")
//                                    .padding(8)
//                                    .foregroundStyle(Color(uiColor: .label))
//                                    .background(Color.gray.opacity(0.4))
//                                    .clipShape(Circle())
//                                
//                                Spacer()
//                                Image(systemName: "arrow.up.right")
//                                    .foregroundStyle(Color(uiColor: .label))
//                            }
//                            Spacer()
//                            Text("Chat \nwith Bot")
//                                .multilineTextAlignment(.leading)
//                                .foregroundStyle(Color(uiColor: .label))
//                                .font(.title)
//                                .fontWeight(.semibold)
//                        }
//                        .padding()
//                        .frame(width: 180, height: 210)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 18))
//                    }
//                    
//                    Spacer()
//                }
//                
//                TipView(historyTip)
//                    .padding(.horizontal)
//                
//                Spacer()
//                
//                Group {
//                    switch viewModel.loadingState {
//                    case .loading, .none:
//                        Text("Loading History...")
//                    case .noResults:
//                    
//                        Text("No History")
//                        Spacer()
//                    case .result:
//                    
//                            List {
//                                ForEach(viewModel.chats) { chat in
//                                    NavigationLink(value: chat.id) {
//                                        VStack(alignment: .leading) {
//                                            Text(chat.topic ?? "New Chat")
//                                                .font(.headline)
//                                            
//                                            Text(chat.lastMessageTimeAgo)
//                                                .font(.caption)
//                                                .foregroundStyle(.gray)
//                                        }
//                                        
//                                    }
//                                    .swipeActions {
//                                        Button(role: .destructive) {
//                                            viewModel.deleteChat(chat: chat)
//                                        } label: {
//                                            Label("Delete", systemImage: "trash.fill")
//                                        }
//                                    }
//                                }
//                            }
//                    }
//                }
//                .onAppear {
//                    if viewModel.loadingState == .none {
//                        viewModel.fetchData()
//                    }
//                    viewModel.fetchCurrentUser()
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowingProfileView) {
//                if let user = viewModel.user {
//                    ProfileView(user: user)
//                }
//            }
////            .navigationDestination(for: String.self) { id in
////                if let item = viewModel.chats.first(where: { $0.id == id }) {
////                    switch item.type {
////                    case .chat:
////                        "ChatView(viewModel: .init(chatId: id))"
////                    case .talk:
////                        TalkView(viewModel: .init(chatId: id))
////                    }
////                } else {
////                    EmptyView()
////                }
////            }
//            .navigationTitle("Hi, \(viewModel.user?.firstName ?? "Welcome")")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if let user = viewModel.user {
//                        Button {
//                            viewModel.showProfile()
//                        } label: {
//                            CircularProfileImageView(user: user, size: .xSmall)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

#Preview {
    HomeView()
}
