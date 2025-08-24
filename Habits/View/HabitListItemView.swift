//
//  HabitDetailView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/20/25.
//

import SwiftUI

struct HabitListItemView: View {
    @State var habit: HabitEvent
    
    var body: some View {
        HStack{
            IconView(habit: habit, iconSize: 25)
            Text("\(habit.habitName)").bold()
            Spacer()
            Text("\(habit.streak) Days Streak.").foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HabitListItemView(habit: HabitEvent.getSampleDataForPreview()).frame(width: 300, height: 50)
}
