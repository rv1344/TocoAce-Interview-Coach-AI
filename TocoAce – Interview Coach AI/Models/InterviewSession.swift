//
//  InterviewSession.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation

struct InterviewMessage: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let text: String
    let isAnswer: Bool
    
    init(text: String, isAnswer: Bool) {
        self.id = UUID()
        self.timestamp = Date()
        self.text = text
        self.isAnswer = isAnswer
    }
}

class InterviewSession: ObservableObject, Codable {
    let id: UUID
    let startDate: Date
    @Published var messages: [InterviewMessage]
    @Published var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, startDate, messages, isActive
    }
    
    init() {
        self.id = UUID()
        self.startDate = Date()
        self.messages = []
        self.isActive = true
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        startDate = try container.decode(Date.self, forKey: .startDate)
        messages = try container.decode([InterviewMessage].self, forKey: .messages)
        isActive = try container.decode(Bool.self, forKey: .isActive)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(messages, forKey: .messages)
        try container.encode(isActive, forKey: .isActive)
    }
    
    func addTranscription(_ text: String) {
        let message = InterviewMessage(text: text, isAnswer: false)
        messages.append(message)
    }
    
    func addAnswer(_ text: String) {
        let message = InterviewMessage(text: text, isAnswer: true)
        messages.append(message)
    }
}


