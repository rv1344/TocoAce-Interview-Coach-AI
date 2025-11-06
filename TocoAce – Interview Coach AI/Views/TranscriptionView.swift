//
//  TranscriptionView.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI

struct TranscriptionView: View {
    let transcribedText: String
    let isRecording: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Live Transcription", systemImage: "waveform")
                    .font(.headline)
                Spacer()
                if isRecording {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .fill(Color.red.opacity(0.3))
                                    .frame(width: 16, height: 16)
                                    .scaleEffect(isRecording ? 1.5 : 1.0)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isRecording)
                            )
                        Text("Recording")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            ScrollView {
                Text(transcribedText.isEmpty ? "Start recording to see transcription..." : transcribedText)
                    .font(.body)
                    .foregroundColor(transcribedText.isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .frame(height: 120)
            .background(Color(nsColor: .textBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isRecording ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 1.5)
            )
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
}


