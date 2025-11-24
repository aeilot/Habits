import SwiftUI
import OpenAI

struct AIChatView: View {
    @State private var messages: [String] = []
    @State private var input: String = ""
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("baseUrl") private var baseUrl: String = ""
    @AppStorage("aiEnabled") private var aiEnabled: Bool = false
    @AppStorage("model") private var model: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            List(messages, id: \ .self) { message in
                Text(message)
            }
            HStack {
                TextField("Type your prompt...", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).onSubmit {
                        sendMessage()
                    }
                Button(isLoading ? "Loading..." : "Send") {
                        sendMessage()
                    }.disabled(isLoading)
            }
            .padding()
        }
        #if os(macOS)
        .frame(minWidth: 300, minHeight: 400)
        #endif
        .navigationTitle("AI Chat")
    }
    
    private func sendMessage() {
        guard !input.isEmpty else { return }
        messages.append("You: " + input)
        isLoading = true
        Task {
            defer { input = "" }
            do {
                guard let url = URL(string: baseUrl),
                      url.scheme == "https",
                      let host = url.host else {
                    throw NSError(domain: "Invalid Base URL", code: -1)
                }
                
                // Preserve path for providers like OpenRouter (/api/v1)
                let basePath = url.path.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let configuration = OpenAI.Configuration(
                    token: apiKey,
                    host: host,
                    scheme: url.scheme ?? "",
                    basePath: basePath.isEmpty ? "/v1" : basePath,
                    parsingOptions: .relaxed
                )
                
                let client = OpenAI(configuration: configuration)
                
                let query = ChatQuery(
                    messages: [
                        .system(.init(content: .textContent("Best Picture winner at the 2011 Oscars"))),
                        .user(.init(content: .string(input)))
                    ],
                    model: model
                )
                
                let result = try await client.chats(query: query)
                
                await MainActor.run {
                    isLoading = false
                    messages.append("AI: " + (result.choices.first?.message.content ?? ""))
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    messages.append("ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatView()
    }
}
