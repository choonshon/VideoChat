//
//  VideoChatApp.swift
//  Shared
//
//  Created by Choon Shon on 2021/06/14.
//

import SwiftUI
import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FirebaseDatabase

@main
struct VideoChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

var db: DatabaseReference! // TODO: 추후 이동

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        db = Database.database(url: "https://videochat-1622690518853-default-rtdb.asia-southeast1.firebasedatabase.app").reference()

        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        SignIn.shared.update()
        
        // Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        
        // Google
        if GIDSignIn.sharedInstance().handle(url) {
            return true
        }
        
        // Facebook
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
