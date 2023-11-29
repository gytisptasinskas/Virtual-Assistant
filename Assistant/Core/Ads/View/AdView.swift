//
//  AdView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 29/11/2023.
//

import SwiftUI

struct AdView: View {
    var body: some View {
        NavigationStack {
                VStack {
                    Image("imageGen")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    
                    List {
                        Section("Features") {
                            ForEach(FeatureSection.allCases) { option in
                                HStack {
                                    Image(systemName: option.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                    
                                    VStack(alignment: .leading) {
                                        Text(option.title)
                                            .font(.headline)
                                        
                                        Text(option.description)
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                    .scrollDisabled(true)
                    
                    Button {
                        
                    } label: {
                        Text("Try out demo")
                            .padding()
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.width - 20)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .navigationTitle("Image Generation")
        }
    }
}

#Preview {
    AdView()
}
