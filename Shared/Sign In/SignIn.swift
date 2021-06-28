//
//  Login.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/18.
//

import Foundation

extension Notification.Name {
    static let signInProcessCompleted: String = "SignInProcessCompleted"
    static let signOutProcessCompleted: String = "SignOutProcessCompleted"
}

struct SignIn {
    enum Service: String, Encodable {
        case google
    }
}

protocol LoginService {
    func signIn()
    func signOut()
}
