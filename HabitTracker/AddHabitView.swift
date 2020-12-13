//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Waveline Media on 12/10/20.
//

import SwiftUI

struct AddHabitView: View {
    @State private var showValidationAlert = false
    @State private var habitTitle = ""
    @State private var habitDescription = ""
    @State private var habitDayCount = ""
    @State private var habitDayCountIndex = 2
    @State private var habitDayCountArray = ["30", "100", "365", "Other"]
    @State private var habitImageName: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var habits = Habits()
    
    let allImageNames = ["bio", "breakfast", "dumbbell", "exercise", "heart_health", "meditation", "no_smoking", "no_sugar", "park", "pills", "sleep", "sleep2", "sunrise", "toothbrush", "water"]
    
    
    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                Form {
                    Section(header: "Habit Title") {
                        TextField("Hydration", text: $habitTitle)
                    }
                    
                    Section(header: "Habit Description") {
                        TextField("To drink 1l of water everyday", text: $habitDescription)
                    }
                    
                    Section(header: "Track habit for:") {
                        Picker("Track habit for:", selection: $habitDayCountIndex, content: {
                            ForEach(0 ..< habitDayCountArray.count) {
                                Text(habitDayCountArray[$0])
                            }
                        }).pickerStyle(SegmentedPickerStyle())
                        TextField("Enter number of days", text: $habitDayCount)
                            .hidden(habitDayCountIndex != habitDayCountArray.count - 1)
                    }
                    
                    Section(header: "Select an icon *optional* :") {
                        VStack {
                            ForEach(0 ..< 3) {rowIndex in
                                HStack {
                                    ForEach(0 ..< 5) {colIndex in
                                        let currentIndex = (rowIndex * 5) + colIndex
                                        Button(action: {
                                            //Add button action
                                            self.habitImageName = allImageNames[currentIndex]
                                        }, label: {
                                            Image(allImageNames[currentIndex])
                                                .resizable()
                                        })
                                        .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                                        .padding(3)
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: self.saveHabit) { Text("Add Habit") }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Add New Habit")
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Validation Error"),
                      message: Text("Please enter the data correctly"),
                      dismissButton: .default(Text("Okay")) {
                        self.showValidationAlert = false
                })
            }
        }
    }
    
    func saveHabit() {
        if self.habitDayCountIndex != self.habitDayCountArray.count - 1 {
            self.habitDayCount = habitDayCountArray[habitDayCountIndex]
        }
        if self.validateHabit() {
            if let actualDayCount = Int(self.habitDayCount) {
                let newItem = Habit(title: self.habitTitle, description: self.habitDescription, habitDays: actualDayCount, icon: self.habitImageName)
                self.habits.items.append(newItem)
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

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
            case true: self.hidden()
            case false: self
        }
    }
}
