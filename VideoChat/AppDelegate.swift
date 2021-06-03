//
//  AppDelegate.swift
//  VideoChat
//
//  Created by CHOON SHON on 2021/06/03.
//

import UIKit
import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        GIDSignIn.sharedInstance().clientID = "444327769387-k6mf50mid3gjg1c3u4jvd9i4663r3lms.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let user = user {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(userId, idToken, fullName, givenName, familyName, email)
        }
        
        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
//            if (isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
//              // The user is a multi-factor user. Second factor challenge is required.
//              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//              var displayNameString = ""
//              for tmpFactorInfo in (resolver.hints) {
//                displayNameString += tmpFactorInfo.displayName ?? ""
//                displayNameString += " "
//              }
//              self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
//                var selectedHint: PhoneMultiFactorInfo?
//                for tmpFactorInfo in resolver.hints {
//                  if (displayName == tmpFactorInfo.displayName) {
//                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                  }
//                }
//                PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
//                  if error != nil {
//                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
//                  } else {
//                    self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
//                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
//                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
//                      resolver.resolveSignIn(with: assertion!) { authResult, error in
//                        if error != nil {
//                          print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
//                        } else {
//                          self.navigationController?.popViewController(animated: true)
//                        }
//                      }
//                    })
//                  }
//                }
//              })
//            } else {
//              print("😨",error.localizedDescription)
//              return
//            }
            // ...
            return
          }
          print("😆 Signed In!!")
        }
    }
}

