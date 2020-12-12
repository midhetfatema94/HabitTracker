//
//  DisplayHabitView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/12/20.
//

import SwiftUI

struct DisplayHabitView: View {
    @ObservedObject var habits = Habits()
    @State var habitId = UUID()
    var displayedHabit: Habit
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let displayIcon = displayedHabit.icon {
                    Image(displayIcon)
                }
                Text(displayedHabit.title)
            }
            Text(displayedHabit.description)
            
            HabitTrackerView(id: self.habitId, allHabits: self.habits)
        }
        .padding()
    }
    
    init(id: UUID, allHabits: Habits) {
        displayedHabit = allHabits.items[0]
        habitId = id
        habits = allHabits
        if let toDisplay = habits.items.first(where: { $0.id == self.habitId }) {
            displayedHabit = toDisplay
        }
    }
}

struct DisplayHabitView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayHabitView(id: UUID(), allHabits: Habits())
    }
}
