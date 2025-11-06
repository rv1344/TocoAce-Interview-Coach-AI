//
//  LocalizationHelper.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

enum SupportedLanguage: String, CaseIterable {
    case english = "en"
    case russian = "ru"
    case kazakh = "kk"
    case polish = "pl"
    case swedish = "sv"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        case .kazakh: return "Қазақша"
        case .polish: return "Polski"
        case .swedish: return "Svenska"
        }
    }
    
    var speechRecognitionCode: String {
        switch self {
        case .english: return "en-US"
        case .russian: return "ru-RU"
        case .kazakh: return "kk-KZ"
        case .polish: return "pl-PL"
        case .swedish: return "sv-SE"
        }
    }
}


