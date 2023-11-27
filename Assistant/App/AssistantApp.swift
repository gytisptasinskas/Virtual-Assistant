//
//  AssistantApp.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import FirebaseCore
import TipKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct AssistantApp: App {
    @StateObject var colorScheme = ColorSchemeService()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(colorScheme)
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    colorScheme.applyColorScheme()
                }
                .task {
                    try? Tips.resetDatastore()
                    try? Tips.configure([
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}

