//
//  SignIn+Facebook.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/28.
//

import Foundation
import FBSDKLoginKit
import Firebase

let facebookSignInService = FacebookLoginService()

struct FacebookLoginService: SignInService {
    var serviceType: SignInServiceType { .facebook }
    
    func signIn() {
        LoginManager().logIn(permissions: ["public_profile", "email"],
                             from: UIApplication.shared.windows.first?.rootViewController) { loginResult, error in
            
            guard let accessToken = AccessToken.current?.tokenString else { return }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            signInFirebaseThenAddToDB(with: credential)
        }
    }
    
    func signOut() {
        LoginManager().logOut()
        signoutFromFirebase()
    }
}
