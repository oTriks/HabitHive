//
//  AuthManager.swift
//  HabitHive
//
//  Created by Martin Larsson on 2024-05-02.
//

import Foundation
import Firebase

class AuthManager: ObservableObject {
    @Published var currentUserID: String?

    init() {
        setupAuthListener()
    }

    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let userID = user?.uid {
                self?.currentUserID = userID
                print("Logged in User ID: \(userID)")
            } else {
                print("No user is logged in.")
                self?.currentUserID = nil
            }
        }
    }
}
