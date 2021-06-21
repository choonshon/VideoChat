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
import GoogleSignIn

struct SignInView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> SignInViewController {
        return SignInViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignInViewController, context: Context) {
        
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

class SignInViewController: UIViewController {
    
    private let googleSiginInButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Join with Google", for: .normal)
        return button
    }()
    
    private let changeNicknameButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Change nickname to star8080", for: .normal)
        return button
    }()
    
    private let currentUserInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
        let user = Auth.auth().currentUser
        //self.currentUserInfoLabel.text = user.debugDescription
        
        db.collection("users").document(user?.uid ?? "").getDocument { snapshot, error in
            self.currentUserInfoLabel.text = snapshot?.get("nickname") as? String
        }
       
        setupViews()
        bindViews()
    }
    
    private func setupViews() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        
        view.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            vStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        vStackView.addArrangedSubview(googleSiginInButton)
        vStackView.addArrangedSubview(changeNicknameButton)
        vStackView.addArrangedSubview(currentUserInfoLabel)
    }
    
    private func bindViews() {
        googleSiginInButton.rx
            .tap
            .subscribe(onNext: {
                GIDSignIn.sharedInstance().signIn()
            })
            .disposed(by: disposeBag)
        
        changeNicknameButton.rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.changeNickname()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.init(Login.EventName.signInProcessCompleted))
            .debug()
            .compactMap { $0.object.debugDescription }
            .bind(to: currentUserInfoLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func changeNickname() {
        let currentUser = Auth.auth().currentUser
        guard let uid = currentUser?.uid else { return }
        
        db.collection("users").document(uid).updateData(["nickname": "star8080"]) { error in
    
        }
    }
}

