//
//  Tips.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import Foundation
import TipKit

struct StartFirstConversation: Tip {
    var title: Text {
        Text("Start your first conversation")
    }
    
    var message: Text? {
        Text("Tap here to start talking and when you finished your question press the button again")
    }
    
    var image: Image? {
        Image(systemName: "mic.fill")
    }
}

struct ConversationList: Tip {
    var title: Text {
        Text("Chat and conversations")
    }
    
    var message: Text? {
        Text("Your chats and conversation history will appear here")
    }
}

struct ProfileImage: Tip {
    var title: Text {
        Text("Add Profile Image")
    }
    
    var message: Text? {
        Text("You can change your profile Image")
    }
    
    var image: Image? {
        Image(systemName: "person.circle.fill")
    }
}
