//
//  Item.swift
//  Habits
//
//  Created by Chenluo Deng on 8/19/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class HabitEvent: Codable {
    public enum CodingKeys: CodingKey {
        case habitName
        case createDate
        case colorHex
        case iconSystemName
        case checkDates
    }
    
    public var habitName: String
    public var createDate: Date
    public var colorHex: String
    public var iconSystemName: String
    var checkDates: [Date]
    
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
        get{
            Color(hex: colorHex)
        }
        
        set(newColor){
            self.colorHex = newColor.toHexString() ?? "007AFF"
        }
    }
    
    @Transient var checkedToday: Bool{
        get {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            return checkDates.contains(today)
        }
        
        set(newBool) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            if newBool {
                checkDates.append(today)
            } else {
                checkDates.removeAll(where: { calendar.isDate($0, inSameDayAs: today) } )
            }
        }
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
    
    required init(from decoder: Decoder) throws{
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.habitName = try! container.decode(String.self, forKey: .habitName)
        self.createDate = try! container.decode(Date.self, forKey: .createDate)
        self.colorHex = try! container.decode(String.self, forKey: .colorHex)
        self.iconSystemName = try! container.decode(String.self, forKey: .iconSystemName)
        self.checkDates = try! container.decode([Date].self, forKey: .checkDates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(habitName, forKey: .habitName)
        try! container.encode(createDate, forKey: .createDate)
        try! container.encode(colorHex, forKey: .colorHex)
        try! container.encode(iconSystemName, forKey: .iconSystemName)
        try! container.encode(checkDates, forKey: .checkDates)
    }
    
    // MARK: - Streak Data Generation Methods
    
    /// Returns streak data for the last N days
    func getStreakData(forLastDays days: Int) -> [(date: Date, completed: Bool)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let normalizedCheckDates = Set(checkDates.map { calendar.startOfDay(for: $0) })
        
        var streakData: [(date: Date, completed: Bool)] = []
        
        for i in (0..<days).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let completed = normalizedCheckDates.contains(date)
                streakData.append((date: date, completed: completed))
            }
        }
        
        return streakData
    }
    
    /// Returns streak data for the current week (Sunday to Saturday)
    func getWeekStreakData() -> [(date: Date, completed: Bool)] {
        let calendar = Calendar.current
        let today = Date()
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else {
            return getStreakData(forLastDays: 7)
        }
        
        let startOfWeek = weekInterval.start
        let normalizedCheckDates = Set(checkDates.map { calendar.startOfDay(for: $0) })
        
        var streakData: [(date: Date, completed: Bool)] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                let normalizedDate = calendar.startOfDay(for: date)
                let completed = normalizedCheckDates.contains(normalizedDate)
                streakData.append((date: normalizedDate, completed: completed))
            }
        }
        
        return streakData
    }
    
    /// Returns streak data for the current month
    func getMonthStreakData() -> [(date: Date, completed: Bool)] {
        let calendar = Calendar.current
        let today = Date()
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: today) else {
            return getStreakData(forLastDays: 30)
        }
        
        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end
        let normalizedCheckDates = Set(checkDates.map { calendar.startOfDay(for: $0) })
        
        var streakData: [(date: Date, completed: Bool)] = []
        var currentDate = startOfMonth
        
        while currentDate < endOfMonth {
            let normalizedDate = calendar.startOfDay(for: currentDate)
            let completed = normalizedCheckDates.contains(normalizedDate)
            streakData.append((date: normalizedDate, completed: completed))
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        
        return streakData
    }
    
    public static func getSampleDataForPreview() -> HabitEvent{
        let habit = HabitEvent(habitName: "New Habit", colorHex: "#0000FF", iconSystemName: "sun.max")
        
        // Add some sample check dates for better preview
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for i in [0, 1, 3, 5, 7, 8, 10] {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                habit.checkDates.append(date)
            }
        }
        
        return habit
    }
}
