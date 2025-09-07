//
//  HabitDetailView.swift
//  Habits
//
//  Created by Chenluo Deng on 8/20/25.
//

import SwiftUI
import SymbolPicker

struct HabitDetailView: View {
    @Bindable var habit: HabitEvent
    @State private var isPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header section with icon and name
                HStack {
                    IconView(habit: habit).sheet(isPresented: $isPresented, content: {
                        VStack(alignment: .center) {
                            SymbolPicker(symbol: $habit.iconSystemName)
                            ColorPicker("Color", selection: $habit.color, supportsOpacity: false).background(.regularMaterial)
                            Spacer()
                        }.background(.regularMaterial)
                    }).padding()
                    .onTapGesture {
                        isPresented = true
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Habit Name", text: $habit.habitName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Created \(habit.createDate.formatted())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Streak visualization
                StreakView(habit: habit)
                
                Spacer()
            }.frame(minWidth: 220)
            .padding()
        }
    }
}

#Preview {
    HabitDetailView(habit: HabitEvent.getSampleDataForPreview())
}
