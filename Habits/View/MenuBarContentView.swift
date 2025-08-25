//
//  MenuBarContentView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/20/25.
//

import SwiftUI
import SwiftData

struct MenuBarContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [HabitEvent]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 8) {
                ForEach(habits) { habit in
                    HStack(spacing: 12) {
                        IconView(habit: habit)
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
                            .fill(Color.gray.opacity(0.15))
                    )
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
