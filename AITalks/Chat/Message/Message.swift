//
//  Message.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 14/6/23.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    
    var user: User
    
    enum User: String, CaseIterable, Codable, Identifiable {
        var id: String {
            rawValue
        }
        
        case mrWhite
        case mrBlack
        
        var username: String {
            switch self {
            case .mrWhite:
                return "Mr. White"
                
            case .mrBlack:
                return "Mr. Black"
            }
        }
    }
    
    var text: String
}
