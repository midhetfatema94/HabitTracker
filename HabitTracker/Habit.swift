//
//  Habit.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/10/20.
//

import Foundation

struct Habit: Codable, Identifiable {
    var id = UUID()
    let title: String
    let description: String
    let habitDays: Int
    let icon: String?
    
    var dateAdded = Date()
    var daysSpent: Int {
        let calendar = Calendar.current

        let date1 = calendar.startOfDay(for: dateAdded)
        let date2 = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return (components.day ?? 0) + 1
    }
    
    var streak: Int
    var habitRecordedDays = [Int]()
}
