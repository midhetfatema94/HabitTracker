//
//  HabitTrackerView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/12/20.
//

import SwiftUI

struct HabitTrackerView: View {
    @ObservedObject var habits = Habits()
    @State var habitId = UUID()
    var displayedHabitIndex = 0
    
    var rows: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0 ..< rows) {rowIndex in
                    HStack {
                        ForEach(1 ..< 9) {colIndex in
                            let currentDay = (rowIndex * 8) + colIndex
                            Button(action: {
                                //Add button action
                                if currentDay <= habits.items[displayedHabitIndex].daysSpent {
                                    self.habits.items[displayedHabitIndex].habitRecordedDays.append(currentDay)
                                }
                            }, label: {
                                Text("\(currentDay)")
                            })
                            .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                            .hidden(currentDay > habits.items[displayedHabitIndex].habitDays)
                            .foregroundColor(getButtonColor(currentDay: currentDay))
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    init(id: UUID, allHabits: Habits) {
        habitId = id
        habits = allHabits
        if let toDisplay = habits.items.firstIndex(where: { $0.id == self.habitId }) {
            displayedHabitIndex = toDisplay
        }
        rows = Int(ceil(Double(habits.items[displayedHabitIndex].habitDays)/8))
        print("no of rows: ", rows)
    }
    
    func getButtonColor(currentDay: Int) -> Color {
        if habits.items[displayedHabitIndex].habitRecordedDays.contains(currentDay) {
            return .green
        } else if currentDay > habits.items[displayedHabitIndex].daysSpent {
            return .blue
        } else {
            return .red
        }
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(id: UUID(), allHabits: Habits())
    }
}
