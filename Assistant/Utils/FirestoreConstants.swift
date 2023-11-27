//
//  FirestoreConstants.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import Foundation
import Firebase

struct FirestoreConstants {
    static let Root = Firestore.firestore()
    
    static let UsersCollection = Root.collection("users")
    
    static let MessagesCollection = Root.collection("messages")
}
