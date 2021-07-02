//
//  Follow.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/07/01.
//

import Foundation
import Firebase


struct FollowService {
    static func follow(_ uid: String) {
        guard let myUid = Auth.auth().currentUser?.uid else { return }

        db.child("follow/followers/\(uid)").setValue([myUid: true]) { error, _ in
            
            if error == nil {
                print("Following Succeeded.")
                return
            }
            
            print("Following Failed", error.debugDescription)
        }
        
        
        db.child("follow/followings/\(myUid)").setValue([uid: true]) { error, _ in
            
            if error == nil {
                print("Sucessfully Added to my following list.")
                return
            }
            
            print("Failed to Add to Following List.", error.debugDescription)
        }
    }
    
    static func unfollow(_ uid: String) {
        guard let myUid = Auth.auth().currentUser?.uid else { return }

        db.child("follow/followers/\(uid)/\(myUid)").removeValue()
        db.child("follow/followings/\(myUid)/\(uid)").removeValue()
    }
}
