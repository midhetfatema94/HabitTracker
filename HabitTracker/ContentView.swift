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
                    NavigationLink(destination: Text("Destination")) {
                        if let iconName = habit.icon {
                            Image(iconName)
                        }
                        
                        Text(habit.title)
                        
                        Spacer()
                        
                        if habit.streak > 0 {
                            Text("\(habit.streak)")
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
