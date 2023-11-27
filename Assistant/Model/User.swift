//
//  User.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import Foundation

struct User: Identifiable, Codable, Hashable {
    @DocumentID var userId: String?
    let fullname: String
    let email: String
    var uid: String
    var profileImageUrl: String?
    
    var id: String {
        return userId ?? NSUUID().uuidString
    }
    
    var firstName: String {
        let components = fullname.components(separatedBy: " ")
        return components.first ?? fullname
    }
}

extension User {
    static let Mock_User = User(fullname: "Gytis Ptasinskas", email: "g.ptasinskas@gmail.com", uid: UUID().uuidString, profileImageUrl: "cat_photo")
}
