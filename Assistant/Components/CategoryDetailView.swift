//
//  CategoryDetailView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: ChatBotCategory
    
    var body: some View {
        VStack {
            Text(category.title)
                .font(.largeTitle)
            
            Spacer()
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    CategoryDetailView(category: .booking)
}
