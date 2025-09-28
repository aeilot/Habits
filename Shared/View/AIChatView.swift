import SwiftUI

struct AIChatView: View {
    @State private var messages: [String] = []
    @State private var input: String = ""
    
    var body: some View {
        VStack {
            List(messages, id: \ .self) { message in
                Text(message)
            }
            HStack {
                TextField("Type your prompt...", text: $input)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
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
        // Placeholder for AI response
        messages.append("AI: (response to '" + input + "')")
        input = ""
    }
}

struct AIChatView_Previews: PreviewProvider {
    static var previews: some View {
        AIChatView()
    }
}
