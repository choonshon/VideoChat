//
//  VideoChatApp.swift
//  Shared
//
//  Created by Choon Shon on 2021/06/14.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn

@main
struct VideoChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

var db: Firestore! // TODO: 추후 이동

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        db = Firestore.firestore()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

extension AppDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("😡 sign in error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let authUser = authResult?.user else { assertionFailure("😡 firebase sign in failure"); return }
            
            let uid = authUser.uid
            
            // db 저장 하지말기.
            let a = authUser.providerData
            
            let user = User(
                uid: uid,
                fullName: user.profile.name,
                nickname: "", // TOOD: 가입시, 입력 받기
                email: authUser.email,
                profileImageUrl: authUser.photoURL?.absoluteString,
                services: authUser.providerData.compactMap { $0.providerID }
            )
            
            Self.storeUser(user, forKey: uid)
        }
    }
    
    // TODO: 추후 이동
    static func storeUser(_ user: User, forKey: String) {
        
        do {
            let data = try JSONEncoder().encode(user)
            let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            
            guard let user = dict else {
                assertionFailure() // TODO: 예외 처리
                return
            }
            
            db.collection("users").addDocument(data: user) { error in
                NotificationCenter.default.post(.init(name: .init(Login.EventName.signInProcessCompleted),
                                                      object: user,
                                                      userInfo: nil))
            }
        } catch {
            print("😡 user data serialization error:", error)
        }
    }
}
