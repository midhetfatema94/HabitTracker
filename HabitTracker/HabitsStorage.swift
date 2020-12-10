//
//  HabitsStorage.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/10/20.
//

import Foundation

class Habits: ObservableObject {
    @Published var items = [Habit]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let expenseItems = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: expenseItems) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}
