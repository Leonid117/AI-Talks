//
//  APIService.swift
//  GPTTalks
//
//  Created by Leonid Volkov on 14/6/23.
//

import Foundation

struct APIService {
    #warning("Remove keys before commit")
    private let apiKey = "sk-....." // your apiKey
        private let organizationKey = "org-...." // your organizationKey
    
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    let encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func createChatCompletion(messages: [Message]) async throws -> Message {
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(organizationKey, forHTTPHeaderField: "OpenAI-Organization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(CompletionBody(messages: messages))
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try decoder.decode(ChatCompletions.self, from: data).choices.first!.message
        }
        catch {
            print(String.init(data: data, encoding: .utf8))
            throw (try? decoder.decode(APIError.self, from: data)) ?? UnknownError.unknown
            
            
        }
    }
    
    struct APIError: LocalizedError, Decodable {
        var errorDescription: String? {
            ""
        }
    }
    enum UnknownError: Error {
        case unknown
    }
    
    struct CompletionBody: Encodable {
        private let model = "gpt-3.5-turbo"
        let messages: [Message]
    }
    
    struct Message: Codable {
        let role: Role
        let content: String
    }
    
    enum Role: String, Codable {
        case system
        case user
        case assistant
    }
    
    struct ChatCompletions: Decodable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let usage: Usage
        
        struct Usage: Decodable {
            let promptTokens: Int
            let completionTokens: Int
            let totalTokens: Int
        }
        
        let choices: [Choice]
        
        struct Choice: Decodable {
            let message: Message
            let finishReason: String
            let index: Int
        }
    }
}
