//
//  SubscriptionStatus.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation

enum SubscriptionTier: String, Codable {
    case free = "free"
    case payPerUse = "pay_per_use"
    case subscription = "subscription"
}

struct SubscriptionStatus: Codable {
    var tier: SubscriptionTier
    var interviewsUsed: Int
    var subscriptionExpiryDate: Date?
    var purchasedInterviews: Int
    
    init() {
        self.tier = .free
        self.interviewsUsed = 0
        self.subscriptionExpiryDate = nil
        self.purchasedInterviews = 0
    }
    
    func canStartInterview() -> Bool {
        switch tier {
        case .free:
            return interviewsUsed < 1
        case .payPerUse:
            return purchasedInterviews > 0
        case .subscription:
            if let expiryDate = subscriptionExpiryDate {
                return Date() < expiryDate
            }
            return false
        }
    }
    
    func remainingInterviews() -> String {
        switch tier {
        case .free:
            return "\(max(0, 1 - interviewsUsed))"
        case .payPerUse:
            return "\(purchasedInterviews)"
        case .subscription:
            if let expiryDate = subscriptionExpiryDate, Date() < expiryDate {
                return "∞"
            }
            return "0"
        }
    }
}


