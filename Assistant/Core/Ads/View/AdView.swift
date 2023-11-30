//
//  AdView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 29/11/2023.
//

import SwiftUI

struct AdView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image("imageGen")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    
                    Text("Image generation is upcoming feature where you will be able to generate your own unique wallpapers images for your phone and be able to share them with your friends")
                        .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading) {
                        Section {
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
                                    Spacer()
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width - 40)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Try out demo")
                            .padding()
                            .foregroundStyle(.white)
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
                .navigationTitle("Image Generation")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }

                    }
                }
            }
        }
    }
}

#Preview {
    AdView()
}
