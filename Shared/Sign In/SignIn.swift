//
//  Login.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/18.
//

import Foundation

struct SignIn {
    
    enum Service: String, Encodable {
        case google
    }
    
    enum EventName {
        static let signInProcessCompleted: String = "SignInProcessCompleted"
    }
}
