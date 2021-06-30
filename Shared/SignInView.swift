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
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
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
        vStackView.addArrangedSubview(currentUserInfoLabel)
    }
    
    private func bindViews() {
        googleSiginInButton.rx
            .tap
            .subscribe(onNext: {
                GIDSignIn.sharedInstance().signIn()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.init(Login.EventName.signInProcessCompleted))
            .debug()
            .compactMap { $0.object.debugDescription }
            .bind(to: currentUserInfoLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
