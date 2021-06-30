//
//  ContentView.swift
//  Shared
//
//  Created by Choon Shon on 2021/06/14.
//

import SwiftUI

struct ContentView: View {
    @State var user: User?
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            if let user = user {
                UserView(user: user)
            } else {
                SignInView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .signInProcessCompleted), perform: { notification in
            self.user = notification.object as? User
        })
        .onReceive(NotificationCenter.default.publisher(for: .signOutProcessCompleted), perform: { notification in
            self.user = nil
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
