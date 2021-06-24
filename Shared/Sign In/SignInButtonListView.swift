//
//  SignIn.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/14.
//

import SwiftUI
import UIKit
import GoogleSignIn
import RxSwift
import RxCocoa
import Firebase
import FirebaseFirestore
import FBSDKLoginKit

struct SignInButtonListView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> SignInViewController {
        return SignInViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignInViewController, context: Context) {
        
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignInButtonListView()
    }
}

class SignInViewController: UIViewController {
    
    let googleSignInButton = GIDSignInButton()
    
    let facebookSignInButton = FBLoginButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        setupViews()
        bindViews()
        
//        if let user = Auth.auth().currentUser {
//            db.collection("users").document(user.uid).getDocument { snapshot, error in
//                //self.currentUserInfoLabel.text = snapshot?.get("nickname") as? String
//            }
//        }
    }
    
    private func setupViews() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        
        view.backgroundColor = .red
        
        view.addSubview(vStackView)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vStackView.topAnchor.constraint(equalTo: view.topAnchor),
            vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        vStackView.addArrangedSubview(googleSignInButton)
        vStackView.addArrangedSubview(facebookSignInButton)
    }
    
    private func bindViews() {
 
    }
    
    func changeNickname() {
//        let currentUser = Auth.auth().currentUser
//        guard let uid = currentUser?.uid else { return }
//
//        db.collection("users").document(uid).updateData(["nickname": "star8080"]) { error in
//
//        }
    }
}

