//
//  HomeViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HomeViewModel: ObservableObject {
    
    @Published var chats: [AppChat] = []
    @Published var loadingState: ChatListState = .none
    @Published var categories: [ChatBotCategory] = ChatBotCategory.allCases
    @Published var isShowingProfileView = false
    @Published var user: User?
    @Published var newChatId: String?
    @Published var newTalkId: String?
    
    private let db = Firestore.firestore()
    
    init() {
        loadSavedCategoryOrder()
    }
    
    // MARK: - Fetching Data
    func fetchData() {
        loadingState = .loading
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            self.loadingState = .noResults
            return
        }
        
        db.collection("chats")
            .whereField("owner", isEqualTo: currentUserUid)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self, let documents = querySnapshot?.documents, !documents.isEmpty else {
                    self?.loadingState = .noResults
                    return
                }
                
                self.chats = documents.compactMap({ snapshot -> AppChat? in
                    return try? snapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSent > $1.lastMessageSent})
                self.loadingState = .result
            }
    }
    
    
    // MARK: - Creating / Deleting Conversations
    func createChat(for category: ChatBotCategory) async {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }

        do {
            let document = try await db.collection("chats").addDocument(data: [
                "topic": "Assistants with \(category.title)",
                "lastMessageSent": Date(),
                "owner": currentUserUid,
                "category": category.title,
                "createdAt": Date(),
                "isFavorite": false
//                "type": ConversationType.chat.rawValue
            ])
            DispatchQueue.main.async {
                self.newChatId = document.documentID
            }
        } catch {
            print("Error creating chat: \(error)")
        }
    }
    
    func createTalk() async {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }

        do {
            let document = try await db.collection("chats").addDocument(data: [
                "lastMessageSent": Date(),
                "owner": currentUserUid,
//                "type": ConversationType.talk.rawValue
            ])
            DispatchQueue.main.async {
                self.newTalkId = document.documentID
            }
        } catch {
            print("Error creating chat: \(error)")
        }
    }
    
    func deleteChat(chat: AppChat) {
        guard let id = chat.id else { return }
        db.collection("chats").document(id).delete()
    }
    
    // MARK: - Current User
    
    func fetchCurrentUser() {
        Task {
            do {
                try await UserService.shared.fetchCurrentUser()
                if let currentUser = UserService.shared.currentUser {
                    DispatchQueue.main.async {
                        self.user = currentUser
                    }
                }
            } catch {
                print("Error fetching current user: \(error)")
            }
        }
    }
    
    // MARK: - Category Ordering
    func reorderCategories(selectedCategory: ChatBotCategory) {
        categories.removeAll { $0 == selectedCategory }
        categories.insert(selectedCategory, at: 0)
        
        saveCategoryOrder()
    }
    
    private func saveCategoryOrder() {
        let categoryTitles = categories.map { $0.title }
        UserDefaults.standard.set(categoryTitles, forKey: "SavedCategoryOrder")
    }
    
    // MARK: - Navigation to ProfileView
    func showProfile() {
        isShowingProfileView = true
    }
    
    func loadSavedCategoryOrder() {
        if let savedOrder = UserDefaults.standard.array(forKey: "SavedCategoryOrder") as? [String] {
            var orderedCategories = [ChatBotCategory]()
            for title in savedOrder {
                if let category = ChatBotCategory.allCases.first(where: { $0.title == title }) {
                    orderedCategories.append(category)
                }
            }
            categories = orderedCategories
        }
    }
}
    
// MARK: - Enums
//enum ConversationType: String, Codable {
//    case chat
//    case talk
//}

//enum ChatListState {
//    case none
//    case loading
//    case noResults
//    case result
//}
