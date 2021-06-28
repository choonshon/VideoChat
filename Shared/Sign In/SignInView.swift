//
//  SignInView2.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/24.
//

import SwiftUI
import URLImage

struct SignInView: View {

    var body: some View {
        VStack {
            Image("welcomeCharacter")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 50)
                .frame(width: 200)
            
            Spacer()
            
            VStack(spacing: 30) {
                
                Button(action: {
                    googleLogin.signIn()
                }) {
                    Text("Sign in With Google")
                }
                
                Button(action: {
                    
                }) {
                    Text("Sign in With Facebook")
                }
            }
            
            Spacer()
                .frame(height: 140)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
