//
//  SettingsView.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    @Environment(\.dismiss) private var dismiss
    @State private var showFileImporter = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // AI Engine Selection
                GroupBox(label: Label("AI Engine", systemImage: "brain")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Select Engine", selection: $settings.aiEngine) {
                            ForEach(AIEngine.allCases, id: \.self) { engine in
                                Text(engine.rawValue).tag(engine)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if settings.aiEngine == .claude {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Anthropic API Key")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                SecureField("sk-ant-...", text: $settings.anthropicAPIKey)
                                    .textFieldStyle(.roundedBorder)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("OpenAI API Key")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                SecureField("sk-...", text: $settings.openAIAPIKey)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    .padding(12)
                }
                
                // Answer Length
                GroupBox(label: Label("Answer Length", systemImage: "text.alignleft")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Length", selection: $settings.answerLength) {
                            ForEach(AnswerLength.allCases, id: \.self) { length in
                                Text(length.rawValue).tag(length)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Text(settings.answerLength.wordRange)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                }
                
                // Job Details
                GroupBox(label: Label("Job Details", systemImage: "briefcase")) {
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Position Level")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Level", selection: $settings.positionLevel) {
                                ForEach(PositionLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Position Title")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("e.g., Senior iOS Developer", text: $settings.positionTitle)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Company Name")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("e.g., Apple Inc.", text: $settings.companyName)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Job Description")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextEditor(text: $settings.jobDescription)
                                .frame(height: 100)
                                .font(.system(.body))
                                .scrollContentBackground(.hidden)
                                .background(Color(nsColor: .textBackgroundColor))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(12)
                }
                
                // Resume Upload
                GroupBox(label: Label("Resume", systemImage: "doc.text")) {
                    VStack(alignment: .leading, spacing: 12) {
                        if !settings.resumeFileName.isEmpty {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(settings.resumeFileName)
                                        .font(.subheadline)
                                    Text("\(settings.resumeText.count) characters")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button(action: {
                                    settings.resumeFileName = ""
                                    settings.resumeText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        Button(action: { showFileImporter = true }) {
                            Label(settings.resumeFileName.isEmpty ? "Upload Resume" : "Replace Resume", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(12)
                }
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(24)
        }
        .frame(width: 500, height: 700)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf, .plainText, UTType(filenameExtension: "docx") ?? .data],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result: result)
        }
        .alert("Import Result", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                if let text = DocumentParser.parseDocument(url: url) {
                    settings.resumeText = text
                    settings.resumeFileName = url.lastPathComponent
                    alertMessage = "Resume uploaded successfully!"
                    showAlert = true
                } else {
                    alertMessage = "Failed to parse document. Please try a different file."
                    showAlert = true
                }
            }
            
        case .failure(let error):
            alertMessage = "Error: \(error.localizedDescription)"
            showAlert = true
        }
    }
}


