//
//  DisplayHabitView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/12/20.
//

import SwiftUI

struct DisplayHabitView: View {
    @State private var showingEditHabit = false
    @ObservedObject var habits = Habits()
    var displayedHabitIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    if let displayIcon = habits.items[displayedHabitIndex].icon {
                        Image(displayIcon)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    Text(habits.items[displayedHabitIndex].description)
                        .foregroundColor(.gray)
                        .font(.title3)
                }
                
                HabitTrackerView(index: displayedHabitIndex, allHabits: self.habits)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            }
            .padding()
        }
        .navigationTitle(Text(habits.items[displayedHabitIndex].title))
    }
    
    init(id: UUID, allHabits: Habits) {
        self.habits = allHabits
        if let toDisplay = self.habits.items.firstIndex(where: { $0.id == id }) {
            displayedHabitIndex = toDisplay
        }
    }
}

struct DisplayHabitView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayHabitView(id: UUID(), allHabits: Habits())
    }
}
