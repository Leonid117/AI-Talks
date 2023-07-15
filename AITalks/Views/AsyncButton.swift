//
//  AsyncButton.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 15/6/23.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    
    var action: () async -> Void
    @ViewBuilder var label: () -> Label
    
    @State private var isPerformingTask = false
    
    var body: some View {
        Button {
            isPerformingTask = true
            
            Task {
                await action()
                isPerformingTask = false
            }
        } label: {
            label()
                .opacity(isPerformingTask ? 0 : 1)
        }
        .overlay {
            if isPerformingTask {
                ProgressView()
            }
        }
        .disabled(isPerformingTask)
    }
}
