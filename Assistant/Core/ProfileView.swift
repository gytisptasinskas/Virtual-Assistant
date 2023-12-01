//
//  SwiftUIView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 12/11/2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var colorScheme: ColorSchemeService
    let user: User
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    PhotosPicker(selection: $viewModel.selectedItem) {
                        ZStack(alignment: .bottomTrailing) {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: ProfileImageSize.xLarge.dimension, height: ProfileImageSize.xLarge.dimension)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: user, size: .xLarge)
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(Color(uiColor: .systemBackground))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "camera.circle.fill")
                                    .foregroundStyle(Color(uiColor: .label))
                                    .frame(width: 18, height: 18)
                            }
                        }
                    }
                    
                    Text(user.fullname)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                List {
                    Section("Account") {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Email")
                            
                            Spacer()
                            
                            Text(user.email)
                                .foregroundStyle(Color(.systemGray2))
                        }
                        
                        HStack {
                            Image(systemName: "moon.fill")
                            
                            Spacer()
                            
                            Picker("Color Scheme", selection: $colorScheme.colorScheme) {
                                Text("System").tag(ColorScheme.unspecified)
                                Text("Light").tag(ColorScheme.light)
                                Text("Dark").tag(ColorScheme.dark)
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    
                    Section("About") {
                        ForEach(AboutSection.allCases) { option in
                            if let url = option.url {
                                NavigationLink(destination: WebView(url: url)) {
                                    HStack {
                                        Image(systemName: option.imageName)
                                        Text(option.title)
                                        Spacer()
                                    }
                                }
                            } else {
                                HStack {
                                    Image(systemName: option.imageName)
                                    Text(option.title)
                                    
                                    Spacer()
                                    
                                    Text(option.description)
                                        .foregroundStyle(Color(.systemGray2))
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button("Sign Out") {
                            AuthService.shared.signOut()
                        }
                        
                        Button("Delete Account") {
                            
                        }
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
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

//#Preview {
//    ProfileView(user: User.Mock_User)
//}
