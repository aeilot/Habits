//
//  IconView.swift
//  Habits
//
//  Created by Chenluo Deng on 8/24/25.
//

import SwiftUI

struct IconView: View {
    @State var habit: HabitEvent
    @State var iconSize: CGFloat = 35
    
    var body: some View {
        ZStack{
            Circle().foregroundStyle(habit.color).frame(width: iconSize, height: iconSize)
            Image(systemName: habit.iconSystemName).font(.title3).foregroundStyle(.white)
        }
    }
}

#Preview {
    IconView(habit: HabitEvent.getSampleDataForPreview())
}
