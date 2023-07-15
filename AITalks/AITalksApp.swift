//
//  AITalksApp.swift
//  AITalks
//
//  Created by Leonid Volkov on 16/06/23.
//

import SwiftUI
import AVFoundation

@main
struct AITalksApp: App {
    init() {
        print(AVSpeechSynthesisVoice.speechVoices())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
