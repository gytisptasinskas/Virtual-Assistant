//
//  MessageView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 04/12/2023.
//

import SwiftUI

struct MessageView: View {
    let message: AppMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            Text(message.text)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(message.role == .user ? .blue : .white)
                .foregroundStyle(message.role == .user ? .white : .black)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

