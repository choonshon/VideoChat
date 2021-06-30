//
//  UserInfoView.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/29.
//
import SwiftUI
import GoogleSignIn
import URLImage

struct UserView: View {
  // 2
  @State var user: User?
  @State var showAlert = false

  var body: some View {
        NavigationView {
          VStack {
            HStack {
              // 3
                if let urlString = user?.profileImageUrl, let profileImageURL = URL(string: urlString) {
                    URLImage(url: profileImageURL) { image in
                        image
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70, alignment: .center)
                            .cornerRadius(8)
                    }
                }

              VStack(alignment: .leading) {
                Text(user?.fullName ?? "")
                  .font(.headline)

                Text(user?.email ?? "")
                  .font(.subheadline)
              }

              Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding()
            
            HStack(spacing: 20) {
                Button("Link Facebook") {
                    FacebookLoginService().link()
                }
                
                Button("Unlink Facebook") {
                    FacebookLoginService().unlink()
                }
            }
            
            Spacer()

            // 4
            Button("Sign out") {
                showAlert = true
            }
            .buttonStyle(AuthenticationButtonStyle())
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign Out"),
                      message: Text("Are you Sure??"),
                      primaryButton: .default(Text("Sign Out"), action: { SignIn.shared.signOut() }),
                      secondaryButton: .cancel(Text("Cancel"), action: { showAlert = false })
                )
            }
          }
          .navigationTitle("Welcome")
        }
        .navigationViewStyle(StackNavigationViewStyle())
  }
}


struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}