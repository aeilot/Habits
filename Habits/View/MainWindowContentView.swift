//
//  ContentView.swift
//  Habits
//
//  Created by Chenluo Deng on 8/19/25.
//

import SwiftUI
import SwiftData

struct MainWindowContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habitEvents: [HabitEvent]
    @State private var showAIChat: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(habitEvents) { event in
                    NavigationLink {
                        HabitDetailView(habit: event)
                    } label: {
                        HabitListItemView(habit: event)
                    }
                }.onDelete(perform: deleteItems)
            }
            #if os(macOS)
            .frame(minWidth: 300)
            #endif
            .listStyle(.inset)
            .toolbar {
                ToolbarItem {
                    Button(action: { showAIChat = true }) {
                        Label("Ask AI", systemImage: "message")
                    }
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Habits")
        }
        #if os(macOS)
        .frame(minWidth: 300, idealWidth: 400, maxWidth: 500, minHeight: 300, alignment: .leading)
        #endif
        .sheet(isPresented: $showAIChat) {
            AIChatView()
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
