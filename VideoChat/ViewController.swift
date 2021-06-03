//
//  ViewController.swift
//  VideoChat
//
//  Created by CHOON SHON on 2021/06/03.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()  // Automatically sign in the user.
    }
    
    @IBAction func googleSignInButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

