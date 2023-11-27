//
//  AppTabBarView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI

struct AppTabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            ExploreView()
                .tabItem { Image(systemName: "bubble.left.and.bubble.right.fill") }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            HistoryView()
                .tabItem { Image(systemName: "book.fill") }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            EmptyView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
        }
        .tint(Color(uiColor: .label))
        
    }
}

#Preview {
    AppTabBarView()
}
