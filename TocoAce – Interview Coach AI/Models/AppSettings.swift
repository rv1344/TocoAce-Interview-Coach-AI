//
//  AppSettings.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation

enum AIEngine: String, CaseIterable, Codable {
    case claude = "Claude 3.5 Sonnet"
    case gpt4o = "GPT-4o"
    case gpt4turbo = "GPT-4 Turbo"
    
    var apiIdentifier: String {
        switch self {
        case .claude: return "claude-3-5-sonnet-20241022"
        case .gpt4o: return "gpt-4o"
        case .gpt4turbo: return "gpt-4-turbo"
        }
    }
}

enum AnswerLength: String, CaseIterable, Codable {
    case short = "Short"
    case medium = "Medium"
    case long = "Long"
    
    var wordRange: String {
        switch self {
        case .short: return "30-50 words"
        case .medium: return "80-120 words"
        case .long: return "150-200 words"
        }
    }
    
    var instructionText: String {
        switch self {
        case .short: return "30-50 words, 2-3 sentences"
        case .medium: return "80-120 words, 5-7 sentences"
        case .long: return "150-200 words, detailed response"
        }
    }
}

enum PositionLevel: String, CaseIterable, Codable {
    case junior = "Junior"
    case middle = "Middle"
    case senior = "Senior"
}

class AppSettings: ObservableObject {
    @Published var aiEngine: AIEngine {
        didSet { save() }
    }
    
    @Published var answerLength: AnswerLength {
        didSet { save() }
    }
    
    @Published var positionLevel: PositionLevel {
        didSet { save() }
    }
    
    @Published var positionTitle: String {
        didSet { save() }
    }
    
    @Published var companyName: String {
        didSet { save() }
    }
    
    @Published var jobDescription: String {
        didSet { save() }
    }
    
    @Published var resumeText: String {
        didSet { save() }
    }
    
    @Published var resumeFileName: String {
        didSet { save() }
    }
    
    @Published var anthropicAPIKey: String {
        didSet { save() }
    }
    
    @Published var openAIAPIKey: String {
        didSet { save() }
    }
    
    private let defaults = UserDefaults.standard
    
    init() {
        self.aiEngine = AIEngine(rawValue: defaults.string(forKey: "aiEngine") ?? "") ?? .claude
        self.answerLength = AnswerLength(rawValue: defaults.string(forKey: "answerLength") ?? "") ?? .medium
        self.positionLevel = PositionLevel(rawValue: defaults.string(forKey: "positionLevel") ?? "") ?? .middle
        self.positionTitle = defaults.string(forKey: "positionTitle") ?? ""
        self.companyName = defaults.string(forKey: "companyName") ?? ""
        self.jobDescription = defaults.string(forKey: "jobDescription") ?? ""
        self.resumeText = defaults.string(forKey: "resumeText") ?? ""
        self.resumeFileName = defaults.string(forKey: "resumeFileName") ?? ""
        self.anthropicAPIKey = defaults.string(forKey: "anthropicAPIKey") ?? ""
        self.openAIAPIKey = defaults.string(forKey: "openAIAPIKey") ?? ""
    }
    
    private func save() {
        defaults.set(aiEngine.rawValue, forKey: "aiEngine")
        defaults.set(answerLength.rawValue, forKey: "answerLength")
        defaults.set(positionLevel.rawValue, forKey: "positionLevel")
        defaults.set(positionTitle, forKey: "positionTitle")
        defaults.set(companyName, forKey: "companyName")
        defaults.set(jobDescription, forKey: "jobDescription")
        defaults.set(resumeText, forKey: "resumeText")
        defaults.set(resumeFileName, forKey: "resumeFileName")
        defaults.set(anthropicAPIKey, forKey: "anthropicAPIKey")
        defaults.set(openAIAPIKey, forKey: "openAIAPIKey")
    }
    
    func isConfigured() -> Bool {
        return !resumeText.isEmpty && !positionTitle.isEmpty && !jobDescription.isEmpty
    }
}


