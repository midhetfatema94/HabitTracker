//
//  EditHabitView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/13/20.
//

import SwiftUI

struct EditHabitView: View {
    @State private var showValidationAlert = false
    @State private var habitTitle = ""
    @State private var habitDescription = ""
    @State private var habitDayCount = ""
    @State private var habitDayCountIndex = 2
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var habits = Habits()
    
    let habitDayCountArray = ["30", "100", "365", "Other"]
    
    var displayedHabitIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Habit Title")
                    TextField("Hydration", text: $habitTitle)
                }
                
                Section {
                    Text("Habit Description")
                    TextField("To drink 1l of water everyday", text: $habitDescription)
                }
                
                Section {
                    Text("Track habit for:")
                    Picker("Track habit for:", selection: $habitDayCountIndex, content: {
                        ForEach(0 ..< habitDayCountArray.count) {
                            Text(habitDayCountArray[$0])
                        }
                    }).pickerStyle(SegmentedPickerStyle())
                    TextField("Enter number of days", text: $habitDayCount)
                        .hidden(habitDayCountIndex != habitDayCountArray.count - 1)
                }
                
                HStack {
                    Spacer()
                    Button(action: self.saveHabit) { Text("Edit Habit") }
                    Spacer()
                }
            }
            .navigationTitle("Edit Habit - \(self.habits.items[displayedHabitIndex].title)")
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
            )
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Validation Error"),
                      message: Text("Please enter the data correctly"),
                      dismissButton: .default(Text("Okay")) {
                        self.showValidationAlert = false
                })
            }
        }
    }
    
    init(index: Int, allHabits: Habits) {
        self.habits = allHabits
        displayedHabitIndex = index
        
        let editHabit = self.habits.items[displayedHabitIndex]
        habitTitle = editHabit.title
        habitDescription = editHabit.description
        habitDayCountIndex = habitDayCountArray.firstIndex(where: { $0 == "\(editHabit.habitDays)" }) ?? habitDayCountArray.count - 1
        habitDayCount = "\(editHabit.habitDays)"
    }
    
    func saveHabit() {
        if self.habitDayCountIndex != self.habitDayCountArray.count - 1 {
            self.habitDayCount = habitDayCountArray[habitDayCountIndex]
        }
        if self.validateHabit() {
            if let actualDayCount = Int(self.habitDayCount) {
                let editedItem = Habit(title: self.habitTitle, description: self.habitDescription, habitDays: actualDayCount, icon: nil)
                self.habits.items[displayedHabitIndex] = editedItem
                self.presentationMode.wrappedValue.dismiss()
            }
        } else {
            self.showValidationAlert = true
        }
    }
    
    func validateHabit() -> Bool {
        if self.habitTitle.isEmpty {
            return false
        } else if self.habitDescription.isEmpty {
            return false
        } else if habitDayCount.isEmpty {
            return false
        }
        return true
    }
}

struct EditHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EditHabitView(index: 0, allHabits: Habits())
    }
}
