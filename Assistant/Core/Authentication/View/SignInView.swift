//
//  SignInVIew.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
        
        var body: some View {
            NavigationStack {
                VStack {
                    
                    Spacer()
                    
                    // logo image
                    Image("app-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                    
                    // text fields
                    VStack {
                        TextField("Enter your email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .modifier(AuthTextfieldModifier())
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .modifier(AuthTextfieldModifier())
                    }
                    
                    Button {
                        print("Show forgot password")
                    } label: {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.top)
                            .padding(.trailing, 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    Button {
                        Task { try await viewModel.login() }
                    } label: {
                        Text("Login")
                            .modifier(AuthButtonModifier())
                            
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Rectangle()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                        
                        Text("OR")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Rectangle()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    }
                    .foregroundColor(.gray)
                    
                    HStack {
                        Image("google-logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Continue with Google")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemBlue))
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    Divider()
                    
                    NavigationLink {
                        SignUpView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                            
                            Text("Sign Up")
                                .fontWeight(.semibold)
                        }
                        .font(.footnote)
                    }
                    .padding(.vertical, 16)

                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.authError?.description ?? ""))
                }
            }
        }
    }


#Preview {
    SignInView()
}
