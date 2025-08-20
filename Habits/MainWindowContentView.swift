//
//  ContentView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/19/25.
//

import SwiftUI
import SwiftData

struct MainWindowContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habitEvents: [HabitEvent]

    var body: some View {
        NavigationStack {
            List {
                ForEach(habitEvents) { event in
                    NavigationLink {
                        HabitDetailView(habit: event)
                    } label: {
                        Text("\(event.habitName)")
                    }
                }
                .onDelete(perform: deleteItems)
            }.lineSpacing(12)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }.navigationTitle("Habits")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = HabitEvent(habitName: "New Habit", colorHex: Color.blue.toHexString() ?? "#0000FF", iconSystemName: "sun.max")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(habitEvents[index])
            }
        }
    }
}

#Preview {
    MainWindowContentView()
        .modelContainer(for: HabitEvent.self, inMemory: true)
}
