//
//  MessageView.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 14/6/23.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            if message.user == .mrWhite {
                avatarCircle(color: .white)
            } else {
                Spacer()
            }
            
            Text(message.text)
                .padding(.top)
            
            if message.user == .mrBlack {
                avatarCircle(color: .black)
            } else {
                Spacer()
            }
        }
        .padding()
    }
    
    private let avatarSide: CGFloat = 50
    
    private func avatarCircle(color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: avatarSide, height: avatarSide)
    }
}

//#Preview {
//    VStack {
//        MessageView(message: Message(user: .mrWhite, text: "Good morning, \(Message.User.mrBlack.username)!"))
//        MessageView(message: Message(user: .mrBlack, text: "Good morning, \(Message.User.mrWhite.username)!"))
//    }
//    .background(Color.gray.opacity(0.1))
//}
