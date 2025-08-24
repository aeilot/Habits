//
//  HabitDetailView.swift
//  Habits
//
//  Created by 邓陈珞 on 8/20/25.
//

import SwiftUI
import SymbolPicker

struct HabitDetailView: View {
    @Bindable var habit: HabitEvent
    @State private var isPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack{
                ZStack{
                    Circle().foregroundStyle(habit.color).frame(width: 35, height: 35)
                    Image(systemName: habit.iconSystemName).font(.title3).foregroundStyle(.white)
                        .sheet(isPresented: $isPresented, content: {
                            VStack(alignment: .center){
                                SymbolPicker(symbol: $habit.iconSystemName)
                                ColorPicker("Color", selection: $habit.color, supportsOpacity: false).background(.regularMaterial)
                                Spacer()
                            }.background(.regularMaterial)
                        }).padding()
                }.onTapGesture {
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
