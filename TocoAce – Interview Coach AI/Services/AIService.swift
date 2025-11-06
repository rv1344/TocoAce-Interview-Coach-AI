//
//  AIService.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import Foundation

class AIService: ObservableObject {
    @Published var isGenerating: Bool = false
    @Published var lastError: String?
    
    func generateAnswer(
        question: String,
        settings: AppSettings,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        DispatchQueue.main.async {
            self.isGenerating = true
            self.lastError = nil
        }
        
        switch settings.aiEngine {
        case .claude:
            generateWithClaude(question: question, settings: settings, completion: completion)
        case .gpt4o, .gpt4turbo:
            generateWithOpenAI(question: question, settings: settings, completion: completion)
        }
    }
    
    private func generateWithClaude(
        question: String,
        settings: AppSettings,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard !settings.anthropicAPIKey.isEmpty else {
            DispatchQueue.main.async {
                self.isGenerating = false
                self.lastError = "Anthropic API key not configured"
                completion(.failure(NSError(domain: "AIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API key not configured"])))
            }
            return
        }
        
        let systemPrompt = buildSystemPrompt(settings: settings)
        let userPrompt = "Question: \(question)\n\nGenerate a \(settings.answerLength.rawValue.lowercased()) answer that sounds natural and matches the candidate's background."
        
        let payload: [String: Any] = [
            "model": settings.aiEngine.apiIdentifier,
            "max_tokens": 1024,
            "system": systemPrompt,
            "messages": [
                ["role": "user", "content": userPrompt]
            ]
        ]
        
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            completion(.failure(NSError(domain: "AIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(settings.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            DispatchQueue.main.async {
                self.isGenerating = false
                self.lastError = error.localizedDescription
            }
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isGenerating = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "AIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let content = json["content"] as? [[String: Any]],
                   let firstContent = content.first,
                   let text = firstContent["text"] as? String {
                    completion(.success(text))
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let error = json["error"] as? [String: Any],
                          let message = error["message"] as? String {
                    let errorObj = NSError(domain: "AIService", code: 4, userInfo: [NSLocalizedDescriptionKey: message])
                    DispatchQueue.main.async {
                        self.lastError = message
                    }
                    completion(.failure(errorObj))
                } else {
                    let error = NSError(domain: "AIService", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    DispatchQueue.main.async {
                        self.lastError = error.localizedDescription
                    }
                    completion(.failure(error))
                }
            } catch {
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func generateWithOpenAI(
        question: String,
        settings: AppSettings,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard !settings.openAIAPIKey.isEmpty else {
            DispatchQueue.main.async {
                self.isGenerating = false
                self.lastError = "OpenAI API key not configured"
                completion(.failure(NSError(domain: "AIService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API key not configured"])))
            }
            return
        }
        
        let systemPrompt = buildSystemPrompt(settings: settings)
        let userPrompt = "Question: \(question)\n\nGenerate a \(settings.answerLength.rawValue.lowercased()) answer that sounds natural and matches the candidate's background."
        
        let payload: [String: Any] = [
            "model": settings.aiEngine.apiIdentifier,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "max_tokens": 1024,
            "temperature": 0.7
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(NSError(domain: "AIService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(settings.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            DispatchQueue.main.async {
                self.isGenerating = false
                self.lastError = error.localizedDescription
            }
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isGenerating = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "AIService", code: 3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let text = message["content"] as? String {
                    completion(.success(text))
                } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                          let error = json["error"] as? [String: Any],
                          let message = error["message"] as? String {
                    let errorObj = NSError(domain: "AIService", code: 4, userInfo: [NSLocalizedDescriptionKey: message])
                    DispatchQueue.main.async {
                        self.lastError = message
                    }
                    completion(.failure(errorObj))
                } else {
                    let error = NSError(domain: "AIService", code: 5, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    DispatchQueue.main.async {
                        self.lastError = error.localizedDescription
                    }
                    completion(.failure(error))
                }
            } catch {
                DispatchQueue.main.async {
                    self.lastError = error.localizedDescription
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func buildSystemPrompt(settings: AppSettings) -> String {
        var prompt = "You are an interview coach helping a candidate answer questions.\n\n"
        prompt += "Context:\n"
        
        if !settings.resumeText.isEmpty {
            prompt += "- Resume: \(settings.resumeText)\n"
        }
        
        if !settings.positionTitle.isEmpty {
            prompt += "- Job: \(settings.positionTitle)"
            if !settings.companyName.isEmpty {
                prompt += " at \(settings.companyName)"
            }
            prompt += "\n"
        }
        
        prompt += "- Level: \(settings.positionLevel.rawValue)\n"
        
        if !settings.jobDescription.isEmpty {
            prompt += "- Description: \(settings.jobDescription)\n"
        }
        
        prompt += "\nAnswer length requirement: \(settings.answerLength.instructionText)"
        
        return prompt
    }
}


