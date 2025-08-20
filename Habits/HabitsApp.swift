//
//  HabitsApp.swift
//  Habits
//
//  Created by 邓陈珞 on 8/19/25.
//

import SwiftUI
import SwiftData

@main
struct HabitsApp: App {
    @NSApplicationDelegateAdaptor(HabitsAppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            HabitEvent.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra("Habits") {
            ContentView()
        }.modelContainer(sharedModelContainer).menuBarExtraStyle(.window)
    }
}

class HabitsAppDelegate: NSObject, NSApplicationDelegate{
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
