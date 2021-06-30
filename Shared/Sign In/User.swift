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
    let uid: String
    let userId: String // 추후 입력 받기
    let fullName: String
    let email: String?
    let profileImageUrl: String?
    var services: [SignIn.ServiceType]?
}
