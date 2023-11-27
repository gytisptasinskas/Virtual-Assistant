//
//  SignUpViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func createUser() async throws {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, fullname: fullname)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
}
