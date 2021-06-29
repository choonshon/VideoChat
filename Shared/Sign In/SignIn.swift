//
//  Login.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/18.
//

import Foundation
import Firebase

extension Notification.Name {
    static let signInProcessCompleted: Self = .init(rawValue: "SignInProcessCompleted")
    static let signOutProcessCompleted: Self = .init(rawValue: "SignOutProcessCompleted")
}

enum SignInServiceType: String, Encodable {
    case google, facebook
}

protocol SignInService {
    func signIn()
    func signOut()
    
    var serviceType: SignInServiceType { get }
}

extension SignInService {
    
    func signInFirebaseThenAddToDB(with credential: AuthCredential) {
        
        if let currentUser =  Auth.auth().currentUser {
            let linkToCurrrentAccount = currentUser.providerData.compactMap { $0.providerID }.contains(self.serviceType.rawValue)
            if linkToCurrrentAccount {
                currentUser.link(with: credential) { authResult, error in
                    print(authResult?.user)
                }
                return
            }
        }
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let authUser = authResult?.user else { assertionFailure("😡 firebase sign in failure"); return }
            
            let key = authUser.uid
                        
            let user = User(
                uid: authUser.uid,
                fullName: authUser.displayName ?? "",
                nickname: "", // TOOD: 가입시, 입력 받기
                email: authUser.email,
                profileImageUrl: authUser.photoURL?.absoluteString,
                services: authUser.providerData.compactMap { $0.providerID }
            )
            
            self.addUserToDB(user: user, forKey: key)
        }
    }
    
    private func addUserToDB(user: User, forKey: String) {
        do {
            let data = try JSONEncoder().encode(user)
            let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            
            guard let data = dict else {
                assertionFailure() // TODO: 예외 처리
                return
            }
            
            db.collection("users").document(forKey).setData(data) { _ in
                NotificationCenter.default.post(.init(name: .signInProcessCompleted,
                                                      object: user,
                                                      userInfo: nil))
            }
        } catch {
            print("😡 user data serialization error:", error)
        }
    }
    
    func signoutFromFirebase() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(.init(name: .signOutProcessCompleted,
                                                  object: nil,
                                                  userInfo: nil))
        } catch {
            print("😡 sign out error:", error)
        }
    }
}
