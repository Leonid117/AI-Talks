//
//  Chat.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 15/6/23.
//

import Foundation
import AVFoundation

@MainActor
final class Chat: ObservableObject {
    private let apiService = APIService()
    
    @Published var messages: [Message] = []
    
    let synthesizzer = AVSpeechSynthesizer()
    
    @Published var error: Error? = nil
    
    private func send() async {
        do {
            let apiUser: Message.User
            if let lastMessage = messages.last {
                apiUser = lastMessage.user
                
            } else {
                apiUser = .mrWhite
            }
            let apiMessages = messages
                .map { message in
                    APIService.Message(role: message.user == apiUser ? .user : .assistant, content: message.text)
                }
            let firstMessage: APIService.Message
            if apiUser == .mrWhite {
                if messages.isEmpty {
                    firstMessage = APIService.Message(role: .user, content: "Начни диалог от женского лица ")
                } else {
                    firstMessage = APIService.Message(role: .user, content: "Говори как жертва, не более 10 слов в сообщении ")

                }
            } else {
                firstMessage = APIService.Message(role: .user, content: "Говори как агрессор не более 10 слов в сообщении ")
            }
            
            let apiMessage = try await apiService
                .createChatCompletion(messages: [firstMessage] + apiMessages)
            
            let message = Message(user: apiUser == .mrWhite ? .mrBlack : .mrWhite, text: apiMessage.content)
            messages.append(message)
            
            let utterance = AVSpeechUtterance(string: message.text)
            if message.user == .mrWhite {
                utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.ru-RU.Yuri")
                utterance.rate = 0.53
            } else {
//                utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.ru-RU.Yuri")
                utterance.rate = 0.55
            }
            
            //com.apple.voice.enhanced.ru-RU.Yuri
            //com.apple.voice.compact.ru-RU.Milena
            synthesizzer.speak(utterance)
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func conversation() async {
        while isPlaying {
            try? await Task.sleep(for: .seconds(2))
            await send()
        }
    }
    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                Task {
                    await conversation()
                }
            }
        }
    }
}
