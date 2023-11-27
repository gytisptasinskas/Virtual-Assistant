//
//  ExploreView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 27/11/2023.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        NavigationLink(destination: CategoryDetailView(category: category)) {
                            VStack(alignment: .leading) {
                                category.iconImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(category.color)
                                
                                Text(category.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(category.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .frame(width: 170, height: 170)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .secondarySystemBackground)))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExploreView()
}
