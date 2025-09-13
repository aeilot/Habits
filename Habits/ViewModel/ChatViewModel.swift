//
//  ChatViewModel.swift
//  Habits
//
//  Created by Copilot on 12/19/24.
//

import Foundation
import SwiftUI
import OpenAI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let llmProvider = LLMProvider.Providers.OpenAI
    private var openAI: OpenAI?
    private var habitEvents: [HabitEvent]
    
    init(habitEvents: [HabitEvent] = []) {
        self.habitEvents = habitEvents
        setupOpenAI()
    }
    
    private func setupOpenAI() {
        // For now, we'll use a placeholder API key
        // In a real app, this should be configured through settings
        llmProvider.apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "your-api-key-here"
        
        let configuration = llmProvider.getConfiguration()
        openAI = OpenAI(configuration: configuration)
    }
    
    func sendMessage() {
        guard !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: currentInput, isUser: true)
        messages.append(userMessage)
        
        let messageToSend = currentInput
        currentInput = ""
        
        Task {
            await processMessage(messageToSend)
        }
    }
    
    private func processMessage(_ message: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await generateAIResponse(for: message)
            let aiMessage = ChatMessage(content: response, isUser: false)
            messages.append(aiMessage)
        } catch {
            errorMessage = "Failed to get AI response: \(error.localizedDescription)"
            let errorAIMessage = ChatMessage(content: "Sorry, I encountered an error. Please try again.", isUser: false)
            messages.append(errorAIMessage)
        }
        
        isLoading = false
    }
    
    private func generateAIResponse(for message: String) async throws -> String {
        guard let openAI = openAI else {
            throw ChatError.noAPIKeyConfigured
        }
        
        // Create context from habit events using ModelUtils
        let habitContext = ModelUtils.toJSON(habits: habitEvents) ?? "No habit data available"
        
        let systemPrompt = """
        You are a helpful AI assistant for a habit tracking app. You have access to the user's habit data in JSON format below. 
        Help the user analyze their habits, provide insights, suggestions for improvement, and answer questions about their habit tracking journey.
        
        Current habit data:
        \(habitContext)
        
        Please provide helpful, encouraging, and actionable advice based on this data.
        """
        
        let query = ChatQuery(
            messages: [
                .init(role: .system, content: systemPrompt),
                .init(role: .user, content: message)
            ],
            model: .gpt3_5Turbo,
            maxTokens: 500
        )
        
        let result = try await openAI.chats(query: query)
        return result.choices.first?.message.content?.string ?? "I'm sorry, I couldn't generate a response."
    }
    
    func clearMessages() {
        messages.removeAll()
        errorMessage = nil
    }
    
    func updateHabitEvents(_ newHabitEvents: [HabitEvent]) {
        self.habitEvents = newHabitEvents
    }
}

enum ChatError: LocalizedError {
    case noAPIKeyConfigured
    
    var errorDescription: String? {
        switch self {
        case .noAPIKeyConfigured:
            return "OpenAI API key not configured"
        }
    }
}