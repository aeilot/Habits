//
//  HabitDetailView.swift
//  Habits
//
//  Created by Chenluo Deng on 8/20/25.
//

import SwiftUI

struct HabitListItemView: View {
    @State var habit: HabitEvent
    
    var body: some View {
        HStack {
            IconView(habit: habit, iconSize: 25)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(habit.habitName)").bold()
                CompactStreakView(habit: habit)
            }
            Spacer()
            Text("\(habit.streak) Days Streak").foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HabitListItemView(habit: HabitEvent.getSampleDataForPreview()).frame(width: 300, height: 50)
}
