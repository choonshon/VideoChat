//
//  FollowerView.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/07/13.
//

import SwiftUI
import URLImage

struct FollowerView: View {
    
    // 테스트 유저
    let user: User = User(uid: "SyQ7p6IQeLVgMaxKYd68jHUafRC3",
                               userId: "",
                               fullName: "choon shon",
                               email: "",
                               profileImageUrl: "https://lh3.googleusercontent.com/a/AATXAJzYMnEo4jRmyzfO3TkVutEhuRVZtqxZHKT_Jk5w=s96-c")
    
    
    var body: some View {
        List {
            HStack {
                if let urlString = user.profileImageUrl, let profileImageURL = URL(string: urlString) {
                    URLImage(url: profileImageURL) { image in
                        image
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(4)
                    }
                }

                Text(user.fullName)
                    .font(.headline)
                
                Spacer()
                
                Button("Follow") {
                    FollowService.follow(user.uid)
                }
                .buttonStyle(FollowButtonStyle())
                .frame(width: 80)
            }
        }
    }
}

struct FollowerView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerView()
    }
}
