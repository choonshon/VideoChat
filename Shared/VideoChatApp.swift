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

var db: Firestore! // TODO: μΆν μ΄λ

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
            print("π‘ sign in error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let authUser = authResult?.user else { assertionFailure("π‘ firebase sign in failure"); return }
            
            let uid = authUser.uid
            let user = User(
                uid: uid,
                fullName: user.profile.name,
                nickname: "Common Nickname", // TOOD: κ°μμ, μλ ₯ λ°κΈ°
                email: authUser.email,
                profileImageUrl: authUser.photoURL?.absoluteString,
                services: [.google] // μΌλ¨ κ³ μ , μΆν λ³κ²½
            )
            
            self.storeUser(user, forKey: uid)
        }
    }
    
    private func storeUser(_ user: User, forKey: String) {
        
        do {
            let data = try JSONEncoder().encode(user)
            let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            
            guard let user = dict else {
                assertionFailure() // TODO: μμΈ μ²λ¦¬
                return
            }
            
            db.collection("users").document(forKey).setData(user) { error in
                NotificationCenter.default.post(.init(name: .init(Login.EventName.signInProcessCompleted),
                                                      object: user,
                                                      userInfo: nil))
            }
        } catch {
            print("π‘ user data serialization error:", error)
        }
    }
}
