//
//  SubscriptionManager.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation
import StoreKit

class SubscriptionManager: ObservableObject {
    @Published var subscriptionStatus: SubscriptionStatus
    @Published var products: [Product] = []
    @Published var isPurchasing: Bool = false
    
    private let productIDs = [
        "com.tocoace.interview.single",      // $7.99 per interview
        "com.tocoace.subscription.monthly"   // $19.99/month unlimited
    ]
    
    init() {
        // Load saved subscription status
        if let data = UserDefaults.standard.data(forKey: "subscriptionStatus"),
           let status = try? JSONDecoder().decode(SubscriptionStatus.self, from: data) {
            self.subscriptionStatus = status
        } else {
            self.subscriptionStatus = SubscriptionStatus()
        }
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    @MainActor
    func loadProducts() async {
        do {
            let products = try await Product.products(for: productIDs)
            self.products = products
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async -> Bool {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                // Update subscription status based on product type
                if product.id == "com.tocoace.interview.single" {
                    subscriptionStatus.tier = .payPerUse
                    subscriptionStatus.purchasedInterviews += 1
                } else if product.id == "com.tocoace.subscription.monthly" {
                    subscriptionStatus.tier = .subscription
                    if let expirationDate = transaction.expirationDate {
                        subscriptionStatus.subscriptionExpiryDate = expirationDate
                    } else {
                        // If no expiration date, set to 30 days from now
                        subscriptionStatus.subscriptionExpiryDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
                    }
                }
                
                saveSubscriptionStatus()
                await transaction.finish()
                return true
                
            case .userCancelled:
                return false
                
            case .pending:
                return false
                
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }
    
    func startInterview() {
        guard subscriptionStatus.canStartInterview() else {
            return
        }
        
        switch subscriptionStatus.tier {
        case .free:
            subscriptionStatus.interviewsUsed += 1
        case .payPerUse:
            subscriptionStatus.purchasedInterviews -= 1
        case .subscription:
            break // No action needed for subscription
        }
        
        saveSubscriptionStatus()
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }
    
    @MainActor
    private func updateSubscriptionStatus() async {
        // Check for active subscriptions
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if transaction.productID == "com.tocoace.subscription.monthly" {
                    subscriptionStatus.tier = .subscription
                    if let expirationDate = transaction.expirationDate {
                        subscriptionStatus.subscriptionExpiryDate = expirationDate
                    }
                }
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
        
        saveSubscriptionStatus()
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw NSError(domain: "SubscriptionManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Transaction verification failed"])
        case .verified(let safe):
            return safe
        }
    }
    
    private func saveSubscriptionStatus() {
        if let encoded = try? JSONEncoder().encode(subscriptionStatus) {
            UserDefaults.standard.set(encoded, forKey: "subscriptionStatus")
        }
    }
}


