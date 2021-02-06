//
//  EditHabitView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

struct EditHabitView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        _name = State(initialValue: "")
        _goal = State(initialValue: 1)
        _goalPeriod = State(initialValue: 0)
        _colorID = State(initialValue: ColorHelper.randomColor)
        _symbolID = State(initialValue: SymbolHelper.randomSymbol)
        
        cdHabit = nil
    }
    
    init(cdHabit: CDHabit) {
        _name = State(initialValue: cdHabit.titel ?? "")
        _goal = State(initialValue: Int(cdHabit.goal))
        _goalPeriod = State(initialValue: 0)
        _colorID = State(initialValue: cdHabit.colorID)
        _symbolID = State(initialValue: cdHabit.symbolID)
        
        self.cdHabit = cdHabit
    }
    
    let cdHabit: CDHabit?
    
    @State private var name: String
    @State private var goal: Int
    @State private var goalPeriod: Int
    @State private var colorID: ColorHelper.ColorID
    @State private var symbolID: SymbolHelper.SymbolID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    HStack {
                        Text(cdHabit == nil ? "create" : "edit")
                            .font(.system(size: 30, weight: .bold))
                        Spacer()
                    }
                    
                    SaveCancelView(cancelAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        presentationMode.wrappedValue.dismiss()
                    }, saveAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        if let cdHabit = cdHabit {
                            persistence.changeHabit(cdHabit,
                                                    titel: name,
                                                    symbolID: symbolID,
                                                    colorID: colorID,
                                                    goal: Int64(goal),
                                                    goalPeriodID: .daily)
                        }else {
                            persistence.addHabit(titel: name,
                                                 symbolID: symbolID,
                                                 colorID: colorID,
                                                 goal: Int64(goal),
                                                 goalPeriodID: .daily)
                        }
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                
                NameView(name: $name)
                
                HStack(spacing: 20) {
                    SymbolView(color: Color(colorID.rawValue), symbolID: $symbolID)
                    ColorView(colorID: $colorID)
                    Spacer()
                }
                
                GoalPeriodView(goalPeriod: $goalPeriod)
                
                GoalView(goal: $goal)
                
                if let cdHabit = cdHabit {
                    DeleteView(archiveAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        presentationMode.wrappedValue.dismiss()
                    }, resetAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        presentationMode.wrappedValue.dismiss()
                    }, deleteAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        persistence.deleteManagedObject(cdHabit)
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
        .buttonStyle(HabitButtonStyle())
    }
}

private struct NameView: View {
    @Binding var name: String
    
    var body: some View {
        VStack {
            HStack {
                Text("name")
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            
            TextField("name your habit", text: $name)
                .padding()
                .frame(height: 50)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .font(.system(size: 25, weight: .bold))
        }
    }
}

private struct SymbolView: View {
    let color: Color
    @Binding var symbolID: SymbolHelper.SymbolID
    @State private var symbolPickerVisible = false

    var body: some View {
        VStack {
            Text("symbol")
                .font(.system(size: 25, weight: .bold))
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 80, height: 80)
                    .onTapGesture(perform: {
                        HapticFeedbackHelper.buttonFeedback()
                        symbolPickerVisible = true
                    })
                    .fullScreenCover(isPresented: $symbolPickerVisible,
                                     content: {
                                        SymbolPicker(selection: $symbolID, color: color)
                                     })
                
                Image(systemName: symbolID.rawValue)
                    .font(.system(size: 35, weight: .semibold))
            }
        }
    }
}

private struct ColorView: View {
    @Binding var colorID: ColorHelper.ColorID
    @State private var colorPickerVisible = false
    
    var body: some View {
        VStack {
            Text("color")
                .font(.system(size: 25, weight: .bold))
            
            
            Circle()
                .fill(Color(colorID.rawValue))
                .frame(width: 80, height: 80)
                .onTapGesture(perform: {
                    HapticFeedbackHelper.buttonFeedback()
                    colorPickerVisible = true
                })
                .fullScreenCover(isPresented: $colorPickerVisible,
                                 content: {
                                    CustomColorPicker(selection: $colorID)
                                 })
        }
    }
}

private struct GoalPeriodView: View {
    @Binding var goalPeriod: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("goal period")
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            
            Picker(selection: $goalPeriod, label: EmptyView()) {
                Text("daily").tag(0)
                Text("weekly").tag(1)
                Text("monthly").tag(2)
                Text("yearly").tag(3)
            }
            .onChange(of: goalPeriod, perform: { _ in
                HapticFeedbackHelper.buttonFeedback()
            })
            .pickerStyle(SegmentedPickerStyle())
            
            
            if goalPeriod == 0 {
                DayPickerView()
            }
        }
    }
}

private struct DayPickerView: View {
    var body: some View {
        HStack{
            ForEach(Date.veryShortWeekdayArray, id: \.self) { weekdayName in
                Button(action: {
                    HapticFeedbackHelper.buttonFeedback()
                },
                label: {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.6))
                            .frame(height: 50)
                        Text(weekdayName)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(.label))
                    }
                })
            }
        }
    }
}

private struct GoalView: View {
    @Binding var goal: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("goal")
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            
            ZStack {
                GeometryReader { geometry in
                    Text("\(goal)")
                        .padding()
                        .frame(width: geometry.size.width, height: 50, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .font(.system(size: 25, weight: .bold))
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Stepper("stepper", value: $goal, in: 1...100 )
                            .labelsHidden()
                            .onChange(of: goal, perform: { _ in
                                HapticFeedbackHelper.buttonFeedback()
                            })
                        Spacer()
                            .frame(width: 10)
                    }
                    Spacer()
                }
            }
        }
    }
}

private struct SaveCancelView: View {
    let cancelAction: () -> ()
    let saveAction: () -> ()
    
    var body: some View {
        HStack {
            Button(action: cancelAction,
                   label: {
                    GeometryReader { geometry in
                        Text("cancel")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                    }
                   })
            
            Button(action: saveAction,
                   label: {
                    GeometryReader { geometry in
                        Text("save")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                    }
                   })
        }
        .frame(height: 50)
    }
}

private struct DeleteView: View {
    let archiveAction: () -> ()
    let resetAction: () -> ()
    let deleteAction: () -> ()
    
    var body: some View {
        HStack {
            Button(action: archiveAction,
                   label: {
                    GeometryReader { geometry in
                        Text("archive")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                    }
                   })
            
            Button(action: resetAction,
                   label: {
                    GeometryReader { geometry in
                        Text("reset")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.yellow.opacity(0.5))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                    }
                   })
            
            Button(action: deleteAction,
                   label: {
                    GeometryReader { geometry in
                        Text("delete")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.red.opacity(0.5))
                            .cornerRadius(10)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                    }
                   })
        }
        .frame(height: 50)
    }
}
