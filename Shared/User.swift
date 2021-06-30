//
//  User.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/14.
//

import Foundation

struct User: Encodable {
    //let id: String // uuid
    
    //let userId: String? // For client-side use only!
    let uid: String
    let fullName: String
    let nickname: String?
    let email: String?
    let profileImageUrl: String?
    var services: [Login.Service]?
}

// service_name userId
// 별도의 테이블
// key ->.        value
// google choonshon,  문서번호..
// facebook choonshon12, 문서번호..
//
