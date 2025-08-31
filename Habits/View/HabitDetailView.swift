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
        VStack(alignment: .leading, spacing: 12){
            HStack{
                IconView(habit: habit).sheet(isPresented: $isPresented, content: {
                    VStack(alignment: .center){
                        SymbolPicker(symbol: $habit.iconSystemName)
                        ColorPicker("Color", selection: $habit.color, supportsOpacity: false).background(.regularMaterial)
                        Spacer()
                    }.background(.regularMaterial)
                }).padding()
.onTapGesture {
                    isPresented = true
                }
                TextField("Habit Name", text: $habit.habitName)
            }
            Text("Created \(habit.createDate.formatted())")
            Spacer()
        }.padding()
    }
}

#Preview {
    HabitDetailView(habit: HabitEvent.getSampleDataForPreview())
}
