//
//  ExploreView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    @State private var navigateToChat = false
    @State private var selectedChatId: String? = nil
    @State private var selectedCategoryTitle: String? = nil
    
    var body: some View {
        NavigationStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.uniqueTags, id: \.self) { tag in
                            Button {
                                viewModel.selectedTag = viewModel.selectedTag == tag ? nil : tag
                            } label: {
                                Text(tag)
                                    .padding(10)
                                    .foregroundStyle(viewModel.selectedTag == tag ? Color.white : Color(uiColor: .label))
                                    .background(viewModel.selectedTag == tag ? Constants.defaultAccentColor : Color.clear)
                                    .frame(minWidth: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredCategories, id: \.id) { category in
                            Button {
                                Task {
                                    await viewModel.createChat(for: category)
                                    if let chatId = viewModel.newChatId {
                                        selectedChatId = chatId
                                        selectedCategoryTitle = category.title
                                        navigateToChat = true
                                    }
                                }
                            } label: {
                                CategoryCardView(category: category, size: .large)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    NavigationLink(destination: ChatView(viewModel: .init(chatId: viewModel.newChatId ?? "", categoryName: selectedCategoryTitle ?? "")), isActive: $navigateToChat) { EmptyView() }
            }
            .navigationTitle("Chats")
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
                viewModel.fetchCurrentUser()
            }
        }
        .searchable(text: $viewModel.searchText)
        .sheet(isPresented: $viewModel.isShowingProfileView) {
            if let user = viewModel.user {
                ProfileView(user: user)
            }
        }
    }
}



#Preview {
    ExploreView()
}
