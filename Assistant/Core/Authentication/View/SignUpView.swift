//
//  SignUpView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
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
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .autocapitalization(.none)
                    .modifier(AuthTextfieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(AuthTextfieldModifier())
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Sign Up")
                    .modifier(AuthButtonModifier())
                
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign In")
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


#Preview {
    SignUpView()
}
