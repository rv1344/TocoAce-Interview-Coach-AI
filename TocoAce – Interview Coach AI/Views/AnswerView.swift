//
//  AnswerView.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI

struct AnswerView: View {
    let answer: String
    let isGenerating: Bool
    let onCopy: () -> Void
    let onRegenerate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Generated Answer", systemImage: "sparkles")
                    .font(.headline)
                Spacer()
                if !answer.isEmpty {
                    HStack(spacing: 8) {
                        Button(action: onCopy) {
                            Label("Copy", systemImage: "doc.on.doc")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        Button(action: onRegenerate) {
                            Label("Regenerate", systemImage: "arrow.clockwise")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
            }
            
            ScrollView {
                if isGenerating {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Generating answer...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(32)
                } else {
                    Text(answer.isEmpty ? "Click 'Generate Answer' to get a response..." : answer)
                        .font(.body)
                        .foregroundColor(answer.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .textSelection(.enabled)
                }
            }
            .frame(height: 150)
            .background(Color(nsColor: .textBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
}


