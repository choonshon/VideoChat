//
//  SignIn+Google.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/28.
//

import GoogleSignIn
import Firebase

// Google
let googleSignInService = GoogleSignInService()

class GoogleSignInService: NSObject, SignInService {
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn() {
        if GIDSignIn.sharedInstance().currentUser == nil {
            GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
}

extension GoogleSignInService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("😡 sign in error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        signInFirebaseThenAddToDB(with: credential)
    }
}
