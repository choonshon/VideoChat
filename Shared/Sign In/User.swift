//
//  User.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/14.
//
import SwiftUI
import GoogleSignIn
import Firebase

struct User: Encodable {
    //let id: String // uuid
    
    //let userId: String? // For client-side use only!
    let uid: String
    let fullName: String
    let nickname: String?
    let email: String?
    let profileImageUrl: String?
    var services: [String]?
}

// service_name userId
// 별도의 테이블
// key ->.        value
// google choonshon,  문서번호..
// facebook choonshon12, 문서번호..
//
class UserFoo: ObservableObject {
    
    @State var current: User?
    
    init() {
        // TODO
    }
    
    func fetchCurrentUser() {
        self.current = nil
        
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).getDocument { snapshot, error in
                
                guard let fullName = snapshot?.get("fullname") as? String else { return }
                
                let nickname = snapshot?.get("nickname") as? String
                let email = snapshot?.get("email") as? String
                let profileImageUrl = snapshot?.get("profileImageUrl") as? String
                
                self.current = User(uid: user.uid,
                                    fullName: fullName,
                                    nickname: nickname,
                                    email: email,
                                    profileImageUrl: profileImageUrl,
                                    services: user.providerData.map { $0.providerID })
            }
        }
    }
    
    
    func reset() {
        current = nil
    }
}
