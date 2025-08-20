//
//  ContentView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/19/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habitEvents: [HabitEvent]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(habitEvents) { event in
                    NavigationLink {
                        Text("\(event.habitName)")
                    } label: {
                        Text("Hello")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
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
    ContentView()
        .modelContainer(for: HabitEvent.self, inMemory: true)
}
