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
                                    .foregroundStyle(Color(uiColor: .label))
                                    .background(viewModel.selectedTag == tag ? Color.blue.opacity(0.7) : Color.clear)
                                    .frame(minWidth: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                }
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
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
                                VStack(alignment: .leading, spacing: 20) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            category.iconImage
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(category.color)
                                            
                                            Text(category.title)
                                                .font(.title2)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                        }
                                        Text(category.description)
                                            .font(.subheadline)
                                            .foregroundStyle(Color(uiColor: .label))
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    HStack {
                                        ForEach(Array(category.tags.enumerated()), id: \.element) { index, tag in
                                            
                                            if index == 0 {
                                                Text(tag)
                                                    .font(.footnote)
                                                    .foregroundStyle(Color(uiColor: .label))
                                                    .frame(minWidth: 60)
                                                    .padding(10)
                                                    .background(category.color)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                
                                            } else {
                                                Text(tag)
                                                    .font(.footnote)
                                                    .foregroundStyle(Color(uiColor: .label))
                                                    .frame(minWidth: 60)
                                                    .padding(10)
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.primary, lineWidth: 2)
                                                    }
                                            }
                                        }
                                        
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity - 20)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .secondarySystemBackground)))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
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
