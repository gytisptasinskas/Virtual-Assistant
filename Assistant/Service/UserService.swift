//
//  UserService.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await db.collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
}

// MARK: - Update User Data

extension UserService {
    @MainActor
    func updateUserProfileImageUrl(_ profileImageUrl: String) async throws {
        self.currentUser?.profileImageUrl = profileImageUrl
        try await db.collection("users").document(currentUser?.id ?? "").updateData([
            "profileImageUrl": profileImageUrl
        ])
    }
}

