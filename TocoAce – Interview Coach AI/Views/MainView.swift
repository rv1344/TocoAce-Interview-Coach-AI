//
//  MainView.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var settings = AppSettings()
    @StateObject private var speechManager = SpeechRecognitionManager()
    @StateObject private var aiService = AIService()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @StateObject private var currentSession = InterviewSession()
    
    @State private var generatedAnswer: String = ""
    @State private var showSettings = false
    @State private var showSubscription = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 16) {
                // Top bar
                HStack {
                    Text("TocoAce")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Interviews remaining
                    Button(action: { showSubscription = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(subscriptionManager.subscriptionStatus.remainingInterviews()) left")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.plain)
                    .help("Settings")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(nsColor: .controlBackgroundColor))
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Configuration warning
                        if !settings.isConfigured() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Please configure your settings before starting")
                                    .font(.subheadline)
                                Spacer()
                                Button("Open Settings") {
                                    showSettings = true
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        }
                        
                        // Transcription panel
                        TranscriptionView(
                            transcribedText: speechManager.transcribedText,
                            isRecording: speechManager.isRecording
                        )
                        .padding(.horizontal, 20)
                        
                        // Control buttons
                        HStack(spacing: 12) {
                            // Record button
                            Button(action: toggleRecording) {
                                Label(
                                    speechManager.isRecording ? "Stop Recording" : "Start Recording",
                                    systemImage: speechManager.isRecording ? "stop.circle.fill" : "mic.circle.fill"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .tint(speechManager.isRecording ? .red : .blue)
                            .disabled(!settings.isConfigured())
                            
                            // Generate button
                            Button(action: generateAnswer) {
                                Label("Generate Answer", systemImage: "sparkles")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .disabled(speechManager.transcribedText.isEmpty || aiService.isGenerating || !settings.isConfigured())
                            .keyboardShortcut(.space, modifiers: .command)
                        }
                        .padding(.horizontal, 20)
                        
                        // Answer display
                        AnswerView(
                            answer: generatedAnswer,
                            isGenerating: aiService.isGenerating,
                            onCopy: copyAnswer,
                            onRegenerate: generateAnswer
                        )
                        .padding(.horizontal, 20)
                        
                        // Status info
                        if let error = aiService.lastError {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(minWidth: 450, minHeight: 600)
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView(subscriptionManager: subscriptionManager)
        }
        .alert("TocoAce", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkFirstLaunch()
        }
    }
    
    private func checkFirstLaunch() {
        if !settings.isConfigured() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showSettings = true
            }
        }
    }
    
    private func toggleRecording() {
        if speechManager.isRecording {
            speechManager.stopRecording()
        } else {
            // Check if can start interview
            if !subscriptionManager.subscriptionStatus.canStartInterview() {
                alertMessage = "You have no interviews remaining. Please upgrade your plan."
                showAlert = true
                showSubscription = true
                return
            }
            
            // Check authorization
            if speechManager.authorizationStatus != .authorized {
                speechManager.requestAuthorization()
                alertMessage = "Please grant microphone and speech recognition permissions in System Settings."
                showAlert = true
                return
            }
            
            // Start new session
            subscriptionManager.startInterview()
            speechManager.startRecording()
        }
    }
    
    private func generateAnswer() {
        guard !speechManager.transcribedText.isEmpty else { return }
        
        let question = speechManager.transcribedText
        
        aiService.generateAnswer(question: question, settings: settings) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let answer):
                    self.generatedAnswer = answer
                    self.currentSession.addTranscription(question)
                    self.currentSession.addAnswer(answer)
                    
                case .failure(let error):
                    self.alertMessage = "Failed to generate answer: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    private func copyAnswer() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(generatedAnswer, forType: .string)
        
        alertMessage = "Answer copied to clipboard!"
        showAlert = true
    }
}


