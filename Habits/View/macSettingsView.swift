import SwiftUI

import ServiceManagement

struct macSettingView: View {
    @AppStorage("startOnStartup") private var startOnStartup: Bool = false
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("baseUrl") private var baseUrl: String = ""
    @AppStorage("aiEnabled") private var aiEnabled: Bool = false
    @AppStorage("model") private var model: String = ""
    @Environment(\.appearsActive) var appearsActive
    
    var body: some View {
        VStack(alignment: .leading){
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Launch at login", isOn: $startOnStartup)
                    Text("""
                    Add Habits app to the menu bar automatically \
                    when you log in on your Mac.
                    """)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            Divider()
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Enable Habits Agent", isOn: $aiEnabled)
                    if aiEnabled {
                        TextField("Base Url", text: $baseUrl)
                        TextField("Model", text: $model)
                        SecureField("API Key", text: $apiKey)
                    }
                    Text("AI Configuration for Habits Agent")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onChange(of: startOnStartup) { newValue in
            if newValue{
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }.onAppear{
            startOnStartup = (SMAppService.mainApp.status == .enabled)
        }
        .padding()
        .frame(width: 500, height: 200)
    }
}

#Preview {
    macSettingView()
        .padding()
        .frame(width: 500, height: 200)

}
