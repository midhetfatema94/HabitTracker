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
    var streak: Int = 0
}
