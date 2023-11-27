//
//  ContentViewModel.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 16/11/2023.
//

import Foundation
import Combine
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession
            .receive(on: RunLoop.main)
            .sink { [weak self] userSession in
                self?.userSession = userSession
                if userSession == nil {
                    self?.handleUserSessionInvalidation()

                }
            }
            .store(in: &cancellables)
        
        // Subscribe to changes in the current user details
        UserService.shared.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
    
    private func handleUserSessionInvalidation() {
        // Reset the currentUser to nil
        currentUser = nil
    }
}
