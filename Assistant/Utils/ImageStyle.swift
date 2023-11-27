//
//  ImageStyle.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 13/11/2023.
//

import Foundation

enum ImageStyle: String, CaseIterable {
    case surrealism
    case realism
    case treeDRender
    case minimalism
    case retro
    case geometric
    
    var title: String {
        switch self {
        case .surrealism:
            return "Surrealism"
        case .realism:
            return "Realism"
        case .treeDRender:
            return "3D Render"
        case .minimalism:
            return "Minimalism"
        case .retro:
            return "Retro"
        case .geometric:
            return "Geometric"
        }
    }
}
