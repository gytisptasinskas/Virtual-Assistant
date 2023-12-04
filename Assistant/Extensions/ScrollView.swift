//
//  ScrollView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 04/12/2023.
//

import SwiftUI

extension ScrollViewProxy {
    func scrollToBottom(messages: [AppMessage], isGeneratingResponse: Bool = false) {
        if isGeneratingResponse {
            withAnimation { self.scrollTo("placeholder", anchor: .bottom) }
        } else if let lastMessage = messages.last {
            withAnimation { self.scrollTo(lastMessage.id, anchor: .bottom) }
        }
    }
}
