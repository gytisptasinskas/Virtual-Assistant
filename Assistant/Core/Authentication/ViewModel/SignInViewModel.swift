//
//  SignInViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import FirebaseAuth
 
class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func login() async throws {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
}
