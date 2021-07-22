//
//  ButtonStyle.swift
//  VideoChat
//
//  Created by Choon Shon on 2021/07/13.
//

import SwiftUI

struct AuthenticationButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color(.systemIndigo).opacity(0.7) : Color(.systemIndigo))
            .cornerRadius(12)
    }
}

struct FollowButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.all, 6)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color(.systemGreen).opacity(0.7) : Color(.systemGreen))
            .cornerRadius(6)
    }
}
