//
//  ContentView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/10/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habits = Habits()
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { habit in
                    NavigationLink(destination: DisplayHabitView(id: habit.id, allHabits: self.habits)) {
                        if let iconName = habit.icon {
                            Image(iconName)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        Text(habit.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if habit.streak > 0 {
                            HStack(alignment: .center) {
                                Image("fire")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("\(habit.streak)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habit Tracker")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddHabit = true
                }, label: {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddHabit, content: {
                    AddHabitView(habits: self.habits)
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
