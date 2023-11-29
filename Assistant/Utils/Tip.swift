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

struct Disclaimer: Tip {
    let category: ChatBotCategory
    
    var title: Text {
        Text("Disclaimer!")
    }
    var message: Text? {
        switch category {
        case .healthAdvice:
            return Text("Please note that the health advice provided is for general information purposes only and should not replace professional medical advice.")
        case .financialAdvice:
            return Text("Financial information provided is for educational purposes and should not be considered as financial advice from a professional advisor.")
        case .petCare:
            return Text("Pet care information provided is for general guidance only and is not a substitute for professional veterinary advice.")
        case .mentalWellbeing:
            return Text("Mental wellbeing advice is for informational purposes and is not a substitute for professional psychological or psychiatric advice.")
        default:
            return nil
        }
    }
    
    
    var image: Image? {
        Image(systemName: "exclamationmark")
    }
}
