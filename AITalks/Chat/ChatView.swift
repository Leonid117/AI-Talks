//
//  ChatView.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 14/6/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject var chat = Chat()
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack {
                    ForEach(chat.messages) { message in
                        MessageView(message: message)
                            .id(message.id)
                    }
                }
                .onReceive(chat.messages.last.publisher) { message in
                    scrollView.scrollTo(message.id)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                chat.isPlaying.toggle()
            } label: {
                if chat.isPlaying {
                    Image(systemName: "pause")
                } else {
                    Image(systemName: "play")
                }
            }
        }
        .background {
            Color.primary.opacity(0.1)
                .ignoresSafeArea()
        }
    }
}

//#Preview {
//    ChatView()
//        .environment(\.locale, Locale(languageCode: .russian))
//}
