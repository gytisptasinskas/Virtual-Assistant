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
    
    private let db = Firestore.firestore()
    
    var filteredCategories: [String] {
        Set(chats.map { $0.category ?? "Other" }).sorted()
    }
    
    func filterChats(by category: String) {
        if category == "All" {
            filteredChats = chats
        } else {
            filteredChats = chats.filter { $0.category == category }
        }
        sortChats(by: selectedSortingOrder)
    }

    func sortChats(by order: SortingOrder) {
        filteredChats.sort { chat1, chat2 in
            if chat1.isFavorite ?? true && !(chat2.isFavorite ?? true) {
                return true
            } else if !(chat1.isFavorite ?? false) && (chat2.isFavorite ?? false) {
                return false
            }
            
            switch order {
            case .newestFirst:
                return chat1.lastMessageSent > chat2.lastMessageSent
            case .oldestFirst:
                return chat1.lastMessageSent < chat2.lastMessageSent
            }
        }
    }

    
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
                    .filter { $0.type == .chat } // Filter chats by type
                    .sorted(by: { $0.lastMessageSent > $1.lastMessageSent })
                
                DispatchQueue.main.async {
                    self.chats = fetchedChats
                    self.filterChats(by: "All")
                    self.sortChats(by: self.selectedSortingOrder)
                    self.loadingState = fetchedChats.isEmpty ? .noResults : .result
                }
            }
    }

    
    func toggleFavorite(for chat: AppChat) {
        guard let id = chat.id else { return }
        
        if let index = chats.firstIndex(where: { $0.id == id }) {
            withAnimation {
                chats[index].isFavorite?.toggle()
                sortChats(by: selectedSortingOrder)
            }
            
            let updatedFavoriteStatus = chats[index].isFavorite
            db.collection("chats").document(id).updateData(["isFavorite": updatedFavoriteStatus ?? false])
        }
    }

    func deleteChat(chat: AppChat) {
        guard let id = chat.id else { return }
        db.collection("chats").document(id).delete()
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
