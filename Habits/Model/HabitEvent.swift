//
//  Item.swift
//  Habits
//
//  Created by 邓陈珞 on 8/19/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class HabitEvent {
    public var habitName: String
    public var createDate: Date
    public var colorHex: String
    public var iconSystemName: String
    var checkDates: [Date]
    
    public func checkToday(){
        checkDates.append(Date())
    }
    
    @Transient public var streak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)
        
        let normalizedDates = Set(checkDates.map({
            calendar.startOfDay(for: $0)
        }))
        
        var currentStreak = 0
        currentStreak += normalizedDates.contains(today) ? 1 : 0
        
        guard var date = yesterday else { return currentStreak }
        while normalizedDates.contains(date){
            currentStreak += 1
            
            if let previousDay = calendar.date(byAdding: .day, value: -1, to: date){
                date = previousDay
            } else {
                break
            }
        }
        
        return currentStreak
    }
    
    @Transient public var color: Color {
        Color(hex: colorHex)
    }
    
    public init(habitName: String, colorHex: String, iconSystemName: String) {
        self.habitName = habitName
        self.createDate = Date()
        self.colorHex = colorHex
        self.iconSystemName = iconSystemName
        self.checkDates = []
    }
    
    public init(habitName: String, color: Color, iconSystemName: String) {
        self.habitName = habitName
        self.createDate = Date()
        self.colorHex = color.toHexString() ?? "#0000FFFF"
        self.iconSystemName = iconSystemName
        self.checkDates = []
    }
    
    public static func getSampleDataForPreview() -> HabitEvent{
        return HabitEvent(habitName: "New Habit", colorHex: "#0000FF", iconSystemName: "sun.max")
    }
}
