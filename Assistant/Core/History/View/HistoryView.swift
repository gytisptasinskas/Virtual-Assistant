//
//  HistoryView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI
import LottieSwiftUI

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    @State private var selectedCategory: String = "All"
    @State private var playAnimation = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    switch viewModel.loadingState {
                    case .loading, .none:
                            Text("Loading History...")
                    case .noResults:
                        VStack {
                            LottieView(name: "emptyHistory", play: $playAnimation)
                                .lottieLoopMode(.playOnce)
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                            Text("History is empty")
                                .font(.title)
                            Spacer()
                        }
                    case .result:
                        if !viewModel.filteredCategories.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(["All"] + viewModel.filteredCategories, id: \.self) { category in
                                        Button(category) {
                                            selectedCategory = category
                                            viewModel.filterChats(by: category)
                                        }
                                        .padding(10)
                                        .frame(minWidth: 80)
                                        .foregroundStyle(selectedCategory == category ? Color.white : Color(uiColor: .label))
                                        .background(selectedCategory == category ? Constants.defaultAccentColor : Color.clear)
                                        .foregroundStyle(Color(uiColor: .label))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        List {
                            ForEach(viewModel.filteredChats) { chat in
                                NavigationLink(value: chat.id) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if chat.isFavorite ?? false {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(Color(uiColor: .systemYellow))
                                            }
                                            
                                            Text(chat.topic ?? "New Chat")
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            Text(chat.category ?? "Uncategorized")
                                                .padding(6)
                                                .background(Constants.defaultAccentColor)
                                                .foregroundStyle(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                        
                                        Text(chat.lastMessageTimeAgo)
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .contextMenu {
                                    Button(action: {
                                        viewModel.toggleFavorite(for: chat)
                                    }) {
                                        let isFavorite = chat.isFavorite ?? false
                                        Label(isFavorite ? "Unfavorite" : "Favorite", systemImage: isFavorite ? "star.fill" : "star")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        viewModel.deleteChat(chat: chat)
                                    }) {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Newest First") {
                            viewModel.selectedSortingOrder = .newestFirst
                            viewModel.sortChats(by: .newestFirst)
                        }
                        Button("Oldest First") {
                            viewModel.selectedSortingOrder = .oldestFirst
                            viewModel.sortChats(by: .oldestFirst)
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .navigationTitle("Chat History")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isShowingProfileView) {
                if let user = viewModel.user {
                    ProfileView(user: user)
                }
            }
            .navigationDestination(for: String.self) { chatId in
                if let chat = viewModel.chats.first(where: { $0.id == chatId }) {
                    ChatView(viewModel: .init(chatId: chat.id ?? "", categoryName: chat.category ?? ""))
                }
            }
        }
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchData()
                viewModel.filterChats(by: "All")
            }
        }
    }
}

#Preview {
    HistoryView()
}
