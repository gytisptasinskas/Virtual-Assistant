//
//  ColorSchemeManager.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 26/11/2023.
//

import SwiftUI

enum ColorScheme: Int {
    case unspecified, light, dark
}

class ColorSchemeService: ObservableObject {
    
    @AppStorage("colorScheme") var colorScheme: ColorScheme = .unspecified {
        didSet {
            applyColorScheme()
        }
    }
    
    func applyColorScheme() {
        keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: colorScheme.rawValue)!
    }
    
    var keyWindow: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
}
