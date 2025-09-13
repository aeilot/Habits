import SwiftUI
import SwiftData

struct AIChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(habitEvents: [HabitEvent] = []) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(habitEvents: habitEvents))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    if viewModel.messages.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "message.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            Text("Welcome to AI Chat!")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("I can help you analyze your habits, provide insights, and answer questions about your habit tracking journey.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Start by asking me something like:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• How are my habits going?")
                                Text("• What's my best streak?")
                                Text("• Tips for better habits?")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    } else {
                        List(viewModel.messages) { message in
                            MessageRowView(message: message)
                                .listRowSeparator(.hidden)
                                .id(message.id)
                        }
                        .listStyle(.plain)
                        .onChange(of: viewModel.messages.count) { _, _ in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                        .padding(.top, 4)
                }
                
                // Loading Indicator
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("AI is thinking...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
                
                // Input Area
                HStack {
                    TextField("Ask about your habits...", text: $viewModel.currentInput, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...4)
                        .onSubmit {
                            if !viewModel.isLoading {
                                viewModel.sendMessage()
                            }
                        }
                        .disabled(viewModel.isLoading)
                    
                    Button(action: {
                        viewModel.sendMessage()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
                }
                .padding()
            }
            .navigationTitle("AI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        viewModel.clearMessages()
                    }
                    .disabled(viewModel.messages.isEmpty)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
}

struct MessageRowView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity * 0.7, alignment: .trailing)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity * 0.7, alignment: .leading)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatView(habitEvents: [HabitEvent.getSampleDataForPreview()])
    }
}
