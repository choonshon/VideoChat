//
//  SignIn+Google.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/28.
//

import GoogleSignIn
import Firebase

// Google
class GoogleSignInService: NSObject, SignInService {
   
    var serviceType: SignIn.ServiceType { .google }
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func signIn() {
        GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    func link() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func unlink() {
        
    }
    
    func signOut() {
        signoutFromFirebase()
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
