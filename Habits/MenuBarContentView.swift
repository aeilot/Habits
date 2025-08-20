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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MenuBarContentView()
}
