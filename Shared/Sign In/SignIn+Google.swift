//
//  SignIn+Google.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/28.
//

import GoogleSignIn
import Firebase


// Google
let googleLogin = GoogleLoginService()

class GoogleLoginService: NSObject, LoginService {
    
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

         do {
           try Auth.auth().signOut()
         } catch let signOutError as NSError {
           print(signOutError.localizedDescription)
         }
    }
}

extension GoogleLoginService: GIDSignInDelegate {
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
            
            let key = authUser.uid
                        
            let user = User(
                uid: authUser.uid,
                fullName: user.profile.name,
                nickname: "", // TOOD: 가입시, 입력 받기
                email: authUser.email,
                profileImageUrl: authUser.photoURL?.absoluteString,
                services: authUser.providerData.compactMap { $0.providerID }
            )
            
            self.addUserToDB(user: user, forKey: key)
        }
    }
    
    func addUserToDB(user: User, forKey: String) {
        do {
            let data = try JSONEncoder().encode(user)
            let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            
            guard let user = dict else {
                assertionFailure() // TODO: 예외 처리
                return
            }
            
            db.collection("users").addDocument(data: user) { error in
                NotificationCenter.default.post(.init(name: .init(SignIn.EventName.signInProcessCompleted),
                                                      object: user,
                                                      userInfo: nil))
            }
        } catch {
            print("😡 user data serialization error:", error)
        }
    }
}
