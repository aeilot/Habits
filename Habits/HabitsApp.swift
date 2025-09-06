//
//  HabitsApp.swift
//  Habits
//
//  Created by Chenluo Deng on 8/19/25.
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
        Window("Habits", id: "mainWindow"){
            MainWindowContentView()
                .modelContainer(sharedModelContainer)
        }.defaultSize(width: 180, height: 450).windowResizability(.contentSize)
        
        MenuBarExtra("Habits", systemImage: "hammer") {
            MenuBarContentView().frame(minHeight: 250)
        }.modelContainer(sharedModelContainer).menuBarExtraStyle(.window)
        
    }
}

class HabitsAppDelegate: NSObject, NSApplicationDelegate{
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
//        NSApp.setActivationPolicy(.accessory)
    }
}
