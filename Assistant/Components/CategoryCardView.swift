//
//  CategoryCardView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 04/12/2023.
//

import SwiftUI

struct CategoryCardView: View {
    enum Size {
        case small, large
        
        var dimensions: CGSize {
            switch self {
            case .small:
                return CGSize(width: 180, height: 170)
            case .large:
                return CGSize(width: UIScreen.main.bounds.width - 20, height: 170)
            }
        }
    }
    
    let category: ChatBotCategory
    let size: Size
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                category.iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: size == .large ? 30 : 24, height: size == .large ? 30 : 24)
                    .foregroundColor(category.color)
                
                Text(category.title)
                    .font(size == .large ? .title : .headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                
            }
            Spacer()
            
            Text(category.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            if size == .large {
                HStack {
                    ForEach(Array(category.tags.enumerated()), id: \.element) { index, tag in
                        Text(tag)
                            .font(.footnote)
                            .foregroundColor(index == 0 ? .white : .primary)
                            .padding(10)
                            .frame(minWidth: 60)
                            .background(index == 0 ? category.color.opacity(0.7) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(index != 0 ? RoundedRectangle(cornerRadius: 12).stroke(Color.primary, lineWidth: 2) : nil)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
        .frame(width: size.dimensions.width, height: size.dimensions.height)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .secondarySystemBackground)))
    }
}




#Preview {
    VStack {
        CategoryCardView(category: .entertainment, size: .small)
        CategoryCardView(category: .healthAdvice, size: .large)
    }
}
