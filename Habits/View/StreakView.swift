//
//  StreakView.swift
//  Habits
//
//  Created by Chenluo Deng on 9/1/25.
//

import SwiftUI

struct StreakView: View {
    let data: [Bool]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            HStack{
                ForEach(data, id: \.description){ item in
                    if item {
                        RoundedRectangle(cornerRadius: 5).frame(width: 25, height: 25).foregroundStyle(.green).opacity(0.8)
                    } else {
                        RoundedRectangle(cornerRadius: 5).frame(width: 25, height: 25).foregroundStyle(.gray).opacity(0.3)
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    StreakView(data: [true, true, false, false, true, true, false, false, true, true, true, false, false])
}
