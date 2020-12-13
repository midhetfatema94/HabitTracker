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
                let imageDimensions = geometry.size.width/8
                Form {
                    Section(header: Text("Habit Title")) {
                        TextField("Hydration", text: $habitTitle)
                    }
                    
                    Section(header: Text("Habit Description")) {
                        TextField("To drink 1l of water everyday", text: $habitDescription)
                    }
                    
                    Section(header: Text("Track habit for:")) {
                        Picker("Track habit for:", selection: $habitDayCountIndex, content: {
                            ForEach(0 ..< habitDayCountArray.count) {
                                Text(habitDayCountArray[$0])
                            }
                        }).pickerStyle(SegmentedPickerStyle())
                        TextField("Enter number of days", text: $habitDayCount)
                            .hidden(habitDayCountIndex != habitDayCountArray.count - 1)
                    }
                    
                    Section(header: Text("Select an icon (optional) :")) {
                        VStack {
                            ForEach(0 ..< 3) {rowIndex in
                                HStack {
                                    ForEach(0 ..< 5) {colIndex in
                                        let currentIndex = (rowIndex * 5) + colIndex
                                        Image(allImageNames[currentIndex])
                                        .resizable()
                                        .onTapGesture {
                                            print("image tapped: ", currentIndex)
                                            self.habitImageName = allImageNames[currentIndex]
                                        }
                                        .frame(width: imageDimensions, height: imageDimensions)
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
