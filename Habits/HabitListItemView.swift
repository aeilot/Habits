//
//  HabitDetailView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/20/25.
//

import SwiftUI

struct HabitListItemView: View {
    @Bindable var habit: HabitEvent
    
    var body: some View {
        Text("\(habit.habitName)")
    }
}

#Preview {
    HabitListItemView(habit: HabitEvent.getSampleDataForPreview()).frame(width: 300, height: 50)
}
