//
//  ContentView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                OnboardingView()
            } else {
               AppTabBarView()
            }
        }
    }
}

#Preview {
    ContentView()
}
