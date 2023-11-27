//
//  HistoryViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HistoryViewModel: ObservableObject {
    @Published var loadingState: ChatListState = .none
    @Published var chats: [AppChat] = []
    @Published var categories: [ChatBotCategory] = ChatBotCategory.allCases
    @Published var user: User?
    @Published var isShowingProfileView = false
    @Published var filteredChats: [AppChat] = []
    @Published var selectedSortingOrder = SortingOrder.newestFirst
    
    var filteredCategories: [String] {
        Set(chats.map { $0.category ?? "Other" }).sorted()
    }
    
    func filterChats(by category: String) {
        if category == "All" {
            filteredChats = chats
        } else {
            filteredChats = chats.filter { $0.category == category }
        }
    }
    
    func sortChats(by order: SortingOrder) {
        switch order {
        case .newestFirst:
            filteredChats.sort(by: { $0.lastMessageSent > $1.lastMessageSent })
        case .oldestFirst:
            filteredChats.sort(by: { $0.lastMessageSent < $1.lastMessageSent })
        }
    }
    
    private let db = Firestore.firestore()
    
    func fetchData() {
        loadingState = .loading
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            self.loadingState = .noResults
            return
        }
        
        db.collection("chats")
            .whereField("owner", isEqualTo: currentUserUid)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching chats: \(error)")
                    self.loadingState = .noResults
                    return
                }
                
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    self.loadingState = .noResults
                    return
                }
                
                let fetchedChats = documents.compactMap { snapshot -> AppChat? in
                    try? snapshot.data(as: AppChat.self)
                }
                    .sorted(by: { $0.lastMessageSent > $1.lastMessageSent })
                
                DispatchQueue.main.async {
                    self.chats = fetchedChats
                    self.filterChats(by: "All")
                    self.sortChats(by: self.selectedSortingOrder)
                    self.loadingState = .result
                }
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
    
    // MARK: - Navigation to ProfileView
    func showProfile() {
        isShowingProfileView = true
    }
}

enum ChatListState {
    case none
    case loading
    case noResults
    case result
}

enum SortingOrder {
    case newestFirst, oldestFirst
}
