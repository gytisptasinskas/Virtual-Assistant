//
//  Chat.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AppChat: Codable, Identifiable {
    @DocumentID var id: String?
    var topic: String?
    let lastMessageSent: FirestoreDate
    let owner: String
    let createdAt: Date?
    let type: ConversationType
    let category: String?
    var isFavorite: Bool? = false
    
    var lastMessageTimeAgo: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: lastMessageSent.date, to: now)
        
        let timeUnits: [ (value: Int?, unit: String) ] = [
            (components.year, "year"),
            (components.month, "month"),
            (components.day, "day"),
            (components.hour, "hour"),
            (components.minute, "minute"),
            (components.second, "second")
        ]
        
        for timeUnit in timeUnits {
            if let value = timeUnit.value, value > 0 {
                return "\(value) \(timeUnit.unit)\(value == 1 ? "" : "s") ago"
            }
        }
        
        return "just now"
    }
}

extension AppMessage {
    static var placeholder: AppMessage {
        AppMessage(id: "placeholder", text: "", role: .assistant)
    }
}

extension AppMessage {
    var isPlaceholder: Bool {
        self.id == "placeholder"
    }
}

enum ConversationType: String, Codable {
    case chat
    case talk
}

