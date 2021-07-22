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
                .padding(.top, 20)
                .frame(width: 200)
            
            Text("Welcome to\nBetter Me!")
                .fontWeight(.black)
                .foregroundColor(Color(.systemIndigo))
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Text("Become the best version of yourself by tracking your every move.")
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding()

            
            VStack(spacing: 10) {
                // Google Button
                Button(action: {
                    SignIn.shared.getService(.google).signIn()
                }) {
                    Text("Sign in With Google")
                }
                .buttonStyle(AuthenticationButtonStyle())
                
                // Facebook Button
                Button(action: {
                    SignIn.shared.getService(.facebook).signIn()
                }) {
                    Text("Sign in With Facebook")
                }
                .buttonStyle(AuthenticationButtonStyle())
            }
            .padding()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
