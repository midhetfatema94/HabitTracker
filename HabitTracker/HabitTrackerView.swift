//
//  HabitTrackerView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/12/20.
//

import SwiftUI

struct HabitTrackerView: View {
    @ObservedObject var habits = Habits()
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
                                    if habits.items[displayedHabitIndex].habitRecordedDays.contains(currentDay) {
                                        self.habits.items[displayedHabitIndex].habitRecordedDays.removeAll(where: { $0 == currentDay })
                                    } else {
                                        self.habits.items[displayedHabitIndex].habitRecordedDays.append(currentDay)
                                    }
                                }
                            }, label: {
                                Text("\(currentDay)")
                                    .fontWeight(.bold)
                            })
                            .frame(width: geometry.size.width/10, height: geometry.size.width/10)
                            .foregroundColor(getButtonForegroundColor(currentDay: currentDay))
                            .background(getButtonBackgroundColor(currentDay: currentDay))
                            .clipShape(Circle())
                            .padding(1)
                            .hidden(currentDay > habits.items[displayedHabitIndex].habitDays)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    init(index: Int, allHabits: Habits) {
        self.habits = allHabits
        self.displayedHabitIndex = index
        rows = Int(ceil(Double(self.habits.items[displayedHabitIndex].habitDays)/8))
        print("no of rows: ", rows)
    }
    
    func getButtonBackgroundColor(currentDay: Int) -> Color {
        if habits.items[displayedHabitIndex].habitRecordedDays.contains(currentDay) {
            return .green
        } else {
            return .white
        }
    }
    
    func getButtonForegroundColor(currentDay: Int) -> Color {
        if habits.items[displayedHabitIndex].habitRecordedDays.contains(currentDay) {
            return .white
        } else if currentDay > habits.items[displayedHabitIndex].daysSpent {
            return .blue
        } else {
            return .red
        }
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(index: 0, allHabits: Habits())
    }
}
