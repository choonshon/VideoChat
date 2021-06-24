//
//  SignInView2.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/06/24.
//

import SwiftUI
import URLImage

struct SignInView: View {
    let bgImageURL = URL(string: "https://picsum.photos/500")!
    
    var body: some View {
        ZStack {
            URLImage(url: bgImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))
            
            VStack {
                Spacer()
                
                SignInButtonListView()
                    .frame(width: 300, height: 70)
                
                Spacer()
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .colorScheme(.dark)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
