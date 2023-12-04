//
//  HomeView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import TipKit
import LottieSwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State private var navigateToChat = false
    @State private var navigateToTalk = false
    @State private var navigateToAd = false
    @State private var selectedChatId: String? = nil
    @State private var selectedCategoryTitle: String? = nil
    @State private var isDismissed: Bool = true
    @State private var playAnimation = true
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                NavigationLink(destination: TalkView(viewModel: .init(chatId: viewModel.newTalkId ?? "")), isActive: $navigateToTalk) {
                    EmptyView()
                }
                VStack {
                    LottieView(name: "voice", play: $playAnimation)
                        .lottieLoopMode(.loop)
                        .frame(width: 300, height: 300)
                        .onTapGesture {
                            Task {
                                await viewModel.createTalk()
                                navigateToTalk = true
                            }
                        }
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
                        .onTapGesture {
                            navigateToAd = true
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
                            CategoryCardView(category: category, size: .small)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                NavigationLink(destination: ChatView(viewModel: .init(chatId: viewModel.newChatId ?? "", categoryName: selectedCategoryTitle ?? "")), isActive: $navigateToChat) { EmptyView()
                }
            }
            .navigationTitle("Hi, \(viewModel.user?.firstName ?? "Welcome")")
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
        .sheet(isPresented: $viewModel.isShowingProfileView) {
            if let user = viewModel.user {
                ProfileView(user: user)
            }
        }
        .fullScreenCover(isPresented: $navigateToAd) {
            AdView()
        }
    }
}

#Preview {
    HomeView()
}
