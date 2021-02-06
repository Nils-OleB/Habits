//
//  HabitDetailView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let cdHabit: CDHabit
    let updateAction: ()->()
    
    @State private var chartDatePickerVisible = false
    @State private var chartDate = Date()
    @State private var chartRange = Date.DateComponent.week
    
    @State private var habitCalendarDatePickerVisible = false
    @State private var habitCalendarDate = Date()
    
    @State private var editHabitViewVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                HabitDetailViewItem(backgroundColor: Color(cdHabit.colorID.rawValue).opacity(0.3),
                                    content: HabitAddRemoveView(cdHabit: cdHabit, updateAction: updateAction))
                    .frame(height: 150)
                    .buttonStyle(HabitButtonStyle())
                
                HabitDetailViewItem(backgroundColor: Color(cdHabit.colorID.rawValue).opacity(0.3),
                                    content: StreakView(cdHabit: cdHabit))
                
                HabitDetailViewItem(backgroundColor: Color(cdHabit.colorID.rawValue).opacity(0.3),
                                    content: ChartView(chartInformation: ChartInformation(chartRange: chartRange,
                                                                                          referenceDate: chartDate,
                                                                                          cdHabit: cdHabit),
                                                       dateButtonAction: { chartRange in
                                                        DispatchQueue.main.async {
                                                            self.chartRange = chartRange
                                                        }
                                                        
                                                        return {
                                                            HapticFeedbackHelper.buttonFeedback()
                                                            chartDatePickerVisible = true
                                                        }
                                                       }))
                    .frame(height: 250)
                    .fullScreenCover(isPresented: $chartDatePickerVisible,
                                     content: {
                                        CustomDatePicker(pickerInformation: DatePickerInformation(endDate: Date().next(.year).next(.year).next(.year),
                                                                                                  selectedDate: chartDate,
                                                                                                  chooseDay: chartRange == .week),
                                                         selection: $chartDate)
                                     })
                
                HabitDetailViewItem(backgroundColor: Color(cdHabit.colorID.rawValue).opacity(0.3),
                                    content: HabitCalendarView(habitCalendarInformation: HabitCalendarInformation(cdHabit: cdHabit,
                                                                                                                  date: habitCalendarDate),
                                                               dateButtonAction: {
                                                                HapticFeedbackHelper.buttonFeedback()
                                                                habitCalendarDatePickerVisible = true
                                                               }))
                    .frame(height: 350)
                    .fullScreenCover(isPresented: $habitCalendarDatePickerVisible,
                                     content: {
                                        CustomDatePicker(pickerInformation: DatePickerInformation(endDate: Date().next(.year).next(.year).next(.year),
                                                                                                  selectedDate: habitCalendarDate,
                                                                                                  chooseDay: false),
                                                         selection: $habitCalendarDate)
                                     })
                
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
        }
        .navigationTitle(cdHabit.titel ?? "")
        .navigationBarItems(trailing:
                                Button("edit", action: {
                                    HapticFeedbackHelper.buttonFeedback()
                                    editHabitViewVisible = true
                                })
                                .fullScreenCover(isPresented: $editHabitViewVisible,
                                                 content: {
                                                    EditHabitView(cdHabit: cdHabit)
                                                        .environment(\.managedObjectContext, viewContext)
                                                 })
        )
    }
}

struct HabitDetailViewItem<Content: View>: View {
    let backgroundColor: Color
    let content: Content
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .cornerRadius(10)
            
            content
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }
}
