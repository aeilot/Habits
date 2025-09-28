//
//  Habits_iOSApp.swift
//  Habits-iOS
//
//  Created by Chenluo Deng on 9/28/25.
//

import SwiftUI
import SwiftData

@main
struct HabitsApp: App {
    @UIApplicationDelegateAdaptor(HabitAppDelegate.self) var appDelegate
    
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
        WindowGroup("Habits") {
            MainWindowContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

class HabitAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

