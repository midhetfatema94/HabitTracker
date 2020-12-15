//
//  HabitTrackerView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/12/20.
//

import SwiftUI

struct HabitTrackerView: View {
    @State private var showingStreakAwardAlert = false
    @State private var awardMessage = ""
    @ObservedObject var habits = Habits()
    
    let awardCountArray = [5, 10, 21, 30, 60, 100, 365]
    
    var rows: Int = 0
    var displayedHabitIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            let imageDimesions = geometry.size.width/10
            
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
                                    self.calculateStreak(recordedDays: habits.items[displayedHabitIndex].habitRecordedDays)
                                }
                            }, label: {
                                Text("\(currentDay)")
                                    .fontWeight(.bold)
                            })
                            .frame(width: imageDimesions, height: imageDimesions)
                            .modifier(HabitTrackerButton(currentDay: currentDay,
                                                         currentHabit: habits.items[displayedHabitIndex]))
                        }
                    }
                }
                Spacer()
            }
            .alert(isPresented: $showingStreakAwardAlert) {
                Alert(title: Text("Congratulations!"),
                      message: Text(awardMessage),
                      dismissButton: .default(Text("Yay! :)")) {
                        self.showingStreakAwardAlert = false
                })
            }
        }
    }
    
    init(index: Int, allHabits: Habits) {
        self.habits = allHabits
        self.displayedHabitIndex = index
        rows = Int(ceil(Double(self.habits.items[displayedHabitIndex].habitDays)/8))
    }
    
    func calculateStreak(recordedDays: [Int]) {
        //array has been ordered after input
        let daysRecorded = recordedDays.sorted { $0 < $1 }
        var streakCount = 0
        for eachDay in daysRecorded {
            //Checking whether this day is the last day to break out of the loop
            if eachDay == daysRecorded.last { break }
            
            //From an ordered array, you should have a streak in the end to be calculated as a streak.
            if daysRecorded.contains(eachDay + 1) {
                streakCount += 1
            } else {
                streakCount = 0
            }
        }
        habits.items[displayedHabitIndex].streak = streakCount > 0 ? streakCount + 1 : 0
        
        if awardCountArray.contains(streakCount + 1) {
            awardMessage = "You have completed \(streakCount + 1) days! You've got this!"
            showingStreakAwardAlert = true
        } else if streakCount + 1 == habits.items[displayedHabitIndex].habitDays {
            awardMessage = "You have completed all your recorded days! You've nailed this! Kudos to you!"
            showingStreakAwardAlert = true
        }
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(index: 0, allHabits: Habits())
    }
}

struct HabitTrackerButton: ViewModifier {
    
    var currentDay: Int
    var currentHabit: Habit
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(getButtonForegroundColor())
            .background(getButtonBackgroundColor())
            .clipShape(Circle())
            .padding(1)
            .hidden(currentDay > currentHabit.habitDays)
    }
    
    func getButtonBackgroundColor() -> Color {
        if currentHabit.habitRecordedDays.contains(currentDay) {
            return .green
        } else {
            return .white
        }
    }
    
    func getButtonForegroundColor() -> Color {
        if currentHabit.habitRecordedDays.contains(currentDay) {
            return .white
        } else if currentDay > currentHabit.daysSpent {
            return .blue
        } else {
            return .red
        }
    }
}
