//
//  CategoryList.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI

import SwiftUI

enum ChatBotCategory: Int, CaseIterable, Identifiable {
    var id: Int { return self.rawValue }
    
    case booking
    case contentCreation
    case history
    case travel
    case healthAdvice
    case cookingRecipes
    case sportsUpdates
    case languageTranslation
    case financialAdvice
    case educationalResources
    case technologyUpdates
    case entertainment
    case localEvents
    case shoppingAssistance
    case fitnessGuidance
    case petCare
    case gardeningTips
    case mentalWellbeing
    
    var title: String {
        switch self {
        case .booking: return "Booking"
        case .contentCreation: return "Content"
        case .history: return "History"
        case .travel: return "Travel"
        case .healthAdvice: return "Health"
        case .cookingRecipes: return "Cooking"
        case .sportsUpdates: return "Sports"
        case .languageTranslation: return "Translation"
        case .financialAdvice: return "Financial"
        case .educationalResources: return "Educational"
        case .technologyUpdates: return "Technology"
        case .entertainment: return "Entertainment"
        case .localEvents: return "Events"
        case .shoppingAssistance: return "Shopping"
        case .fitnessGuidance: return "Fitness"
        case .petCare: return "Pet Care"
        case .gardeningTips: return "Gardening"
        case .mentalWellbeing: return "Mental"
        }
    }
    
    var description: String {
        switch self {
        case .booking: return "Manage and schedule bookings"
        case .contentCreation: return "Tips and tools for creating engaging content."
        case .history: return "Explore historical events, figures, and eras."
        case .travel: return "Travel guides, tips, and destination information."
        case .healthAdvice: return "General health tips and wellness information."
        case .cookingRecipes: return "Discover new recipes and cooking techniques."
        case .sportsUpdates: return "Latest news and updates in the world of sports."
        case .languageTranslation: return "Translation assistance for various languages."
        case .financialAdvice: return "Guidance on financial planning and investments."
        case .educationalResources: return "Educational materials for learning and development."
        case .technologyUpdates: return "Latest trends and news in technology."
        case .entertainment: return "Updates on movies, music, and pop culture."
        case .localEvents: return "Information on local events and community activities."
        case .shoppingAssistance: return "Assistance with finding products and deals online."
        case .fitnessGuidance: return "Fitness programs and health tips."
        case .petCare: return "Advice on pet health, grooming, and care."
        case .gardeningTips: return "Gardening techniques and plant care tips."
        case .mentalWellbeing: return "Resources for mental health and emotional well-being."
        }
    }
    
    var iconImage: Image {
        switch self {
        case .booking: return Image(systemName: "calendar")
        case .contentCreation: return Image(systemName: "paintbrush.pointed")
        case .history: return Image(systemName: "books.vertical")
        case .travel: return Image(systemName: "airplane")
        case .healthAdvice: return Image(systemName: "cross.case")
        case .cookingRecipes: return Image(systemName: "fork.knife")
        case .sportsUpdates: return Image(systemName: "sportscourt")
        case .languageTranslation: return Image(systemName: "globe")
        case .financialAdvice: return Image(systemName: "dollarsign.circle")
        case .educationalResources: return Image(systemName: "graduationcap")
        case .technologyUpdates: return Image(systemName: "desktopcomputer")
        case .entertainment: return Image(systemName: "film")
        case .localEvents: return Image(systemName: "ticket")
        case .shoppingAssistance: return Image(systemName: "cart")
        case .fitnessGuidance: return Image(systemName: "figure.walk")
        case .petCare: return Image(systemName: "pawprint")
        case .gardeningTips: return Image(systemName: "leaf.arrow.circlepath")
        case .mentalWellbeing: return Image(systemName: "brain.head.profile")
        }
    }
    
    var color: Color {
        switch self {
        case .booking: return Color.blue
        case .contentCreation: return Color.orange
        case .history: return Color.brown
        case .travel: return Color.green
        case .healthAdvice: return Color.red
        case .cookingRecipes: return Color.pink
        case .sportsUpdates: return Color.purple
        case .languageTranslation: return Color.yellow
        case .financialAdvice: return Color.gray
        case .educationalResources: return Color.indigo
        case .technologyUpdates: return Color.teal
        case .entertainment: return Color.mint
        case .localEvents: return Color.pink
        case .shoppingAssistance: return Color.purple
        case .fitnessGuidance: return Color.green
        case .petCare: return Color.orange
        case .gardeningTips: return Color.green
        case .mentalWellbeing: return Color.cyan
        }
    }
}


