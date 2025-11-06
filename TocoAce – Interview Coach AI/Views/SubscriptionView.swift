//
//  SubscriptionView.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.yellow)
                
                Text("Upgrade Your Plan")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Get more interviews and ace your career goals")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            
            // Current Status
            VStack(spacing: 8) {
                Text("Current Plan: \(subscriptionManager.subscriptionStatus.tier.rawValue.uppercased())")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Interviews Remaining: \(subscriptionManager.subscriptionStatus.remainingInterviews())")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(12)
            
            // Products
            if subscriptionManager.products.isEmpty {
                ProgressView("Loading products...")
                    .padding()
            } else {
                VStack(spacing: 12) {
                    ForEach(subscriptionManager.products, id: \.id) { product in
                        ProductCard(
                            product: product,
                            isPurchasing: subscriptionManager.isPurchasing
                        ) {
                            Task {
                                let success = await subscriptionManager.purchase(product)
                                if success {
                                    alertMessage = "Purchase successful! Thank you!"
                                    showAlert = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            // Footer buttons
            VStack(spacing: 12) {
                Button("Restore Purchases") {
                    Task {
                        await subscriptionManager.restorePurchases()
                        alertMessage = "Purchases restored!"
                        showAlert = true
                    }
                }
                .buttonStyle(.bordered)
                
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .frame(width: 450, height: 600)
        .alert("Success", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct ProductCard: View {
    let product: Product
    let isPurchasing: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(product.displayName)
                    .font(.headline)
                
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(product.displayPrice)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Button(action: onPurchase) {
                    if isPurchasing {
                        ProgressView()
                            .scaleEffect(0.7)
                            .frame(width: 80)
                    } else {
                        Text("Purchase")
                            .frame(width: 80)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .disabled(isPurchasing)
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
        )
    }
}


