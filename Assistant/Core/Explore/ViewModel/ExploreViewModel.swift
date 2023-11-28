//
//  ExploreViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class ExploreViewModel: ObservableObject {
    @Published var categories: [ChatBotCategory] = ChatBotCategory.allCases
    @Published var user: User?
    @Published var newChatId: String?
    @Published var newTalkId: String?
    @Published var isShowingProfileView = false
    @Published var selectedTag: String? = nil
    @Published var searchText: String = ""
    
    private let db = Firestore.firestore()
    
    func createChat(for category: ChatBotCategory) async {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }
        
        do {
            let document = try await db.collection("chats").addDocument(data: [
                "lastMessageSent": Date(),
                "owner": currentUserUid,
                "category": category.title,
                "createdAt": Date(),
                "topic": "Assistants with \(category.title)",
//                "type": ConversationType.chat.rawValue
            ])
            DispatchQueue.main.async {
                self.newChatId = document.documentID
            }
        } catch {
            print("Error creating chat: \(error)")
        }
    }
    
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
    
    // MARK: - Navigation to ProfileView
    func showProfile() {
        isShowingProfileView = true
    }
    
    var uniqueTags: [String] {
        var allTags: Set<String> = []
        categories.forEach { category in
            allTags.formUnion(Set(category.tags))
        }
        return Array(allTags).sorted()
    }
    
    var filteredCategories: [ChatBotCategory] {
        categories.filter { category in
            (selectedTag == nil || category.tags.contains(selectedTag!)) &&
            (searchText.isEmpty || category.title.localizedCaseInsensitiveContains(searchText) || category.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) }))
        }
    }
}
