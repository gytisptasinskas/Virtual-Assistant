//
//  File.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 13/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreDate: Codable, Hashable, Comparable {
    var date: Date
    
    init(_ date: Date = Date()) {
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Timestamp.self)
        date = timestamp.dateValue()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let timestamp = Timestamp(date: date)
        try container.encode(timestamp)
    }
    
    static func < (lhs: FirestoreDate, rhs: FirestoreDate) -> Bool {
        lhs.date < rhs.date
    }
}
