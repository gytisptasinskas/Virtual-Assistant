//
//  Message.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import Foundation
import OpenAI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AppMessage: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var text: String
    let role: Chat.Role
    var createdAt: FirestoreDate = FirestoreDate()
}
