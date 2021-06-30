//
//  Login.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/18.
//

import Foundation
import Firebase
import SwiftUI

extension Notification.Name {
    static let signInProcessCompleted: Self = .init(rawValue: "SignInProcessCompleted")
    static let signOutProcessCompleted: Self = .init(rawValue: "SignOutProcessCompleted")
}

class SignIn {
    
    static let shared = SignIn()
    
    enum ServiceType: String, Encodable {
        case google = "google.com"
        case facebook = "facebook.com"
    }
    
    var currentUser: User?
    
    private var currentService: ServiceType?
    
    private var services: [ServiceType: SignInService] = [.facebook: FacebookLoginService(), .google: GoogleSignInService()]
    
    func getService(_ type: ServiceType) -> SignInService {
        currentService = type
        return services[type]!
    }
    
    func update() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        db.collection("users").document(uid).getDocument { snapshot, _ in
            if let snapshot = snapshot, snapshot.exists {
                
                let user = User(uid: uid,
                                userId: snapshot.get("userId") as? String ?? "",
                                fullName: snapshot.get("fullName") as? String ?? "",
                                email: snapshot.get("email") as? String,
                                profileImageUrl: snapshot.get("profileImageUrl") as? String,
                                services: (snapshot.get("services") as? [String])?.compactMap { SignIn.ServiceType(rawValue: $0) }
                )
                
                self.currentUser = user
                
                NotificationCenter.default.post(.init(name: .signInProcessCompleted,
                                                      object: user,
                                                      userInfo: nil))
                return
            }
        }
    }
    
    func signOut() {
        if let service = currentService {
            getService(service).signOut()
        }
    }
    
    func linkToService(_ service: ServiceType) {
    
    }
}

protocol SignInService {
    func signIn()
    func signOut()
    func link()
    func unlink()
    
    var serviceType: SignIn.ServiceType { get }
}

extension SignInService {
    
    func signInFirebaseThenAddToDB(with credential: AuthCredential) {
        guard Auth.auth().currentUser == nil else { return }
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let authUser = authResult?.user else { assertionFailure("😡 firebase sign in failure"); return }
            
            let key = authUser.uid
            
            // 유저 DB 저장 유무 확인
            db.collection("users").document(key).getDocument { snapshot, _ in
                if let snapshot = snapshot, snapshot.exists {
                    
                    let user = User(uid: authUser.uid,
                                    userId: snapshot.get("userId") as? String ?? "",
                                    fullName: snapshot.get("fullName") as? String ?? "",
                                    email: snapshot.get("email") as? String,
                                    profileImageUrl: snapshot.get("profileImageUrl") as? String,
                                    services: (snapshot.get("services") as? [String])?.compactMap { SignIn.ServiceType(rawValue: $0) }
                                )
                    
                    SignIn.shared.currentUser = user
                    
                    NotificationCenter.default.post(.init(name: .signInProcessCompleted,
                                                          object: user,
                                                          userInfo: nil))
                    return
                }
                
                let user = User(
                    uid: authUser.uid,
                    userId: "",
                    fullName: authUser.displayName ?? "",
                    email: authUser.email,
                    profileImageUrl: authUser.photoURL?.absoluteString,
                    services: authUser.providerData.compactMap { SignIn.ServiceType(rawValue: $0.providerID) }
                )
                
                // 신규 유저 저장
                self.addUserToDB(user: user, forKey: key)
            }
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
                
                SignIn.shared.currentUser = user

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
    
    func link(credential: AuthCredential) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.link(with: credential) { authResult, error in
                guard let authUser = authResult?.user else { return }
               
                let user = User(
                    uid: authUser.uid,
                    userId: "",
                    fullName: authUser.displayName ?? "",
                    email: authUser.email,
                    profileImageUrl: authUser.photoURL?.absoluteString,
                    services: authUser.providerData.compactMap { SignIn.ServiceType(rawValue: $0.providerID) }
                )
                
                addUserToDB(user: user, forKey: authUser.uid)
            }
        }
    }
    
    func unlink(providerId: String) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.unlink(fromProvider: providerId) { authUser, error in
                guard let authUser = authUser else { return }
               
                let user = User(
                    uid: authUser.uid,
                    userId: "",
                    fullName: authUser.displayName ?? "",
                    email: authUser.email,
                    profileImageUrl: authUser.photoURL?.absoluteString,
                    services: authUser.providerData.compactMap { SignIn.ServiceType(rawValue: $0.providerID) }
                )
                
                addUserToDB(user: user, forKey: authUser.uid)
            }
        }
    }
}
