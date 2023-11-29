//
//  FeatureSection.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 29/11/2023.
//

import Foundation

enum FeatureSection: Int, CaseIterable, Identifiable {
    case imageGen
    case create
    case showcase
    
    var title: String {
        switch self {
        case .imageGen:
            return "Dall-E 3"
        case .create:
            return "Create"
        case .showcase:
            return "Showcase"
        }
    }
    
    var description: String {
        switch self {
        case .imageGen:
            return "Try out newest Dall-E 3 version"
        case .create:
            return "Create your own unique and amazing artwork"
        case .showcase:
            return "Showcase with your art with the world"
        }
    }
    
    var imageName: String {
        switch self {
        case .imageGen:
            return "photo.artframe"
        case .create:
            return "plus.rectangle.fill"
        case .showcase:
            return "square.and.arrow.up.fill"
        }
    }
    
    var id: Int { return self.rawValue }
}
