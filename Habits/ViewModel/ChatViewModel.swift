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
        // If no OpenAI instance is configured, provide a mock response
        guard let openAI = openAI, llmProvider.apiKey != "your-api-key-here" else {
            // Mock response when API key is not configured
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate API delay
            return generateMockResponse(for: message)
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
    
    private func generateMockResponse(for message: String) -> String {
        let habitContext = ModelUtils.toJSON(habits: habitEvents) ?? "No habit data available"
        
        if message.lowercased().contains("habit") {
            if habitEvents.isEmpty {
                return "I see you haven't started tracking any habits yet! Creating your first habit is a great step toward building positive routines. Would you like some suggestions for good habits to start with?"
            } else {
                let habitCount = habitEvents.count
                let totalCheckDates = habitEvents.reduce(0) { $0 + $1.checkDates.count }
                return "I can see you're tracking \(habitCount) habit\(habitCount == 1 ? "" : "s") with a total of \(totalCheckDates) check-ins! That's great progress. What specific aspect of your habits would you like to discuss?"
            }
        } else if message.lowercased().contains("streak") {
            let bestStreak = habitEvents.map { $0.streak }.max() ?? 0
            return "Your best current streak is \(bestStreak) days! \(bestStreak > 0 ? "Keep up the great work!" : "Don't worry, every expert was once a beginner. Start small and stay consistent!")"
        } else {
            return "I'm here to help you with your habit tracking journey! Ask me about your habits, streaks, or tips for building better routines. (Note: This is a demo response - configure your OpenAI API key for full functionality)"
        }
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