import SwiftUI

#if os(macOS)
import ServiceManagement

struct macSettingView: View {
    @AppStorage("startOnStartup") private var startOnStartup: Bool = false
    @Environment(\.appearsActive) var appearsActive
    
    var body: some View {
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
        }.onChange(of: startOnStartup) { newValue in
            if newValue{
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }.onAppear{
            startOnStartup = (SMAppService.mainApp.status == .enabled)
        }
        .padding()
        .frame(width: 300, height: 100)
    }
}

#Preview {
    macSettingView()
}
#endif
