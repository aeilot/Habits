//
//  StreakView.swift
//  Habits
//
//  Created by Chenluo Deng on 9/1/25.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

enum StreakViewPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case lastThirtyDays = "30 Days"
    
    var displayName: String {
        return self.rawValue
    }
}

struct StreakView: View {
    let habit: HabitEvent
    @State private var selectedPeriod: StreakViewPeriod = .week
    
    private var streakData: [(date: Date, completed: Bool)] {
        switch selectedPeriod {
        case .week:
            return habit.getWeekStreakData()
        case .month:
            return habit.getMonthStreakData()
        case .lastThirtyDays:
            return habit.getStreakData(forLastDays: 30)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with period selector
            VStack(alignment: .leading, spacing: 8) {
                Text("Activity Overview")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(StreakViewPeriod.allCases, id: \.self) { period in
                        Text(period.displayName).tag(period)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // Streak visualization
            if selectedPeriod == .week {
                weekView
            } else if selectedPeriod == .month {
                monthView
            } else {
                thirtyDaysView
            }
            
            // Statistics
            statisticsView
        }
        .padding()
        #if os(macOS)
        .background(Color(NSColor.controlBackgroundColor))
        #else
        .background(Color(UIColor.systemBackground))
        #endif
        .cornerRadius(12)
    }
    
    private var weekView: some View {
        HStack(spacing: 4) {
            Spacer()
            ForEach(Array(streakData.enumerated()), id: \.offset) { index, dayData in
                VStack{
                    Text(dayOfWeekLabel(for: index))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30)

                    StreakSquare(
                        date: dayData.date,
                        completed: dayData.completed,
                        color: habit.color,
                        size: 30
                    )
                }
            }
            Spacer()
        }
    }
    
    private var monthView: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
        
        return VStack(spacing: 8) {
            // Month header
            Text(monthYearFormatter.string(from: streakData.first?.date ?? Date()))
                .font(.subheadline)
                .fontWeight(.medium)
            
            // Day of week headers
            HStack {
                ForEach(0..<7) { index in
                    Text(dayOfWeekLabel(for: index))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(streakData.enumerated()), id: \.offset) { index, dayData in
                    StreakSquare(
                        date: dayData.date,
                        completed: dayData.completed,
                        color: habit.color,
                        size: 20
                    )
                }
            }
        }
    }
    
    private var thirtyDaysView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 3) {
                ForEach(Array(streakData.enumerated()), id: \.offset) { index, dayData in
                    VStack(spacing: 2) {
                        Text("\(Calendar.current.component(.day, from: dayData.date))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        StreakSquare(
                            date: dayData.date,
                            completed: dayData.completed,
                            color: habit.color,
                            size: 16
                        )
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private var statisticsView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(habit.streak) days")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Completion Rate")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(completionPercentage, specifier: "%.0f")%")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.top, 8)
    }
    
    private var completionPercentage: Double {
        guard !streakData.isEmpty else { return 0 }
        let completedCount = streakData.filter { $0.completed }.count
        return Double(completedCount) / Double(streakData.count) * 100
    }
    
    private func dayOfWeekLabel(for index: Int) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "E"
        let calendar = Calendar.current
        
        if let date = calendar.date(bySetting: .weekday, value: index + 1, of: Date()) {
            return String(dayFormatter.string(from: date).prefix(1))
        }
        return ""
    }
    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct StreakSquare: View {
    let date: Date
    let completed: Bool
    let color: Color
    let size: CGFloat
    
    @State private var isHovered = false
    
    private var fillColor: Color {
        if completed {
            return color.opacity(isHovered ? 1.0 : 0.8)
        } else {
            return Color.gray.opacity(isHovered ? 0.3 : 0.15)
        }
    }
    
    private var borderColor: Color {
        if completed {
            return color
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(fillColor)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(borderColor, lineWidth: 0.5)
            )
            .frame(width: size, height: size)
            .scaleEffect(isHovered ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
            .help(tooltipText)
    }
    
    private var tooltipText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        let status = completed ? "Completed" : "Not completed"
        return "\(dateString): \(status)"
    }
}

// Compact streak view for menu bar and list items
struct CompactStreakView: View {
    let habit: HabitEvent
    let maxDays: Int = 7
    
    private var streakData: [(date: Date, completed: Bool)] {
        return habit.getStreakData(forLastDays: maxDays)
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(streakData.enumerated()), id: \.offset) { index, dayData in
                RoundedRectangle(cornerRadius: 2)
                    .fill(dayData.completed ? habit.color.opacity(0.8) : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .help(tooltipText(for: dayData))
            }
        }
    }
    
    private func tooltipText(for dayData: (date: Date, completed: Bool)) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: dayData.date)
        let status = dayData.completed ? "✓" : "✗"
        return "\(dateString): \(status)"
    }
}

// Legacy StreakView for backward compatibility
struct LegacyStreakView: View {
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
    VStack(spacing: 16) {
        Text("Enhanced StreakView")
            .font(.headline)
        StreakView(habit: HabitEvent.getSampleDataForPreview())
            .frame(maxWidth: 400)
        
        Divider()
        
        Text("Compact StreakView")
            .font(.headline)
        CompactStreakView(habit: HabitEvent.getSampleDataForPreview())
        
        Divider()
        
        Text("Legacy StreakView")
            .font(.headline)
        LegacyStreakView(data: [true, true, false, false, true, true, false, false, true, true, true, false, false])
    }
    .padding()
}
