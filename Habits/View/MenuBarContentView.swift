//
//  MenuBarContentView.swift
//  Habits
//
//  Created by Chenluo Deng on 8/20/25.
//

import SwiftUI
import SwiftData

struct MenuBarContentView: View {
    @Environment(\.openWindow) private var openWindow
    
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [HabitEvent]
    
    func getFormattedDate() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return today.formatted(date: .abbreviated, time: .omitted)
    }
    
    func buttonAction() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        openWindow(id: "mainWindow")
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("\(getFormattedDate())").font(.headline)
                Spacer()
                Button(action: buttonAction) {
                    Image(systemName: "house")
                }.focusable(false).buttonStyle(.borderless)
            }.frame(height: 25)
            
            ScrollView{
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(habits) { habit in
                        ExtractedView(habit: habit)
                    }
                }
            }
        }
        .padding()
        .frame(maxHeight: 500)
        .frame(width: 300)
    }
}

#Preview {
    MenuBarContentView()
        .modelContainer(for: HabitEvent.self, inMemory: true)
}

struct ExtractedView: View {
    @State var habit: HabitEvent
    var fillColor: Color {
        if habit.checkedToday {
            return habit.color.opacity(0.15)
        }
        return Color.gray.opacity(0.15)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(habit: habit).symbolEffect(.bounce, value: habit.checkedToday)
            Text(habit.habitName)
                .font(.headline)
            Spacer()
            Text("\(habit.streak) 🔥")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(fillColor)
        ).onTapGesture {
            withAnimation{
                habit.checkedToday.toggle()
            }
        }
    }
}
