//
//  CustomDatePicker.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 20.01.21.
//

import SwiftUI

struct CustomDatePicker: View {
    @ObservedObject var pickerInformation: DatePickerInformation
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selection: Date

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onEnded { value in
                                if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                    switch pickerInformation.type {
                                    case .dayPicker:
                                        selection = pickerInformation.calendarInformation.referenceDate
                                    case .monthPicker:
                                        selection = pickerInformation.dateFromIndices
                                    }
                                    presentationMode.wrappedValue.dismiss()
                                }
                            })
            
            switch pickerInformation.type {
            case .dayPicker:
                DayPicker(pickerInformation: pickerInformation,
                          doneAction: {
                            HapticFeedbackHelper.buttonFeedback()
                            selection = pickerInformation.calendarInformation.referenceDate
                            presentationMode.wrappedValue.dismiss()
                          })
                    .frame(width: 300, height: 300)
            case .monthPicker:
                MonthYearPicker(pickerInformation: pickerInformation,
                                doneAction: {
                                    HapticFeedbackHelper.buttonFeedback()
                                    selection = pickerInformation.dateFromIndices
                                    presentationMode.wrappedValue.dismiss()
                                })
                    .frame(width: 300, height: 300)
            }
        }
    }
        
}

private struct DayPicker: View {
    @ObservedObject var pickerInformation: DatePickerInformation
    var doneAction: () -> ()
    
    var body: some View {
        CalendarView(calendarInformation: pickerInformation.calendarInformation,
                     dateButtonAction: {
                        HapticFeedbackHelper.buttonFeedback()
                        pickerInformation.type = .monthPicker
                     },
                     doneAction: doneAction,
                     backgroundColor: Color(.systemBackground),
                     content: { dayNumber, buttonWidth, referenceDate in
                        Button(action: {
                            HapticFeedbackHelper.buttonFeedback()
                            pickerInformation.calendarInformation.referenceDate = Date(day: dayNumber,
                                                                                       month: pickerInformation.calendarInformation.referenceDate.monthNumber,
                                                                                       year: pickerInformation.calendarInformation.referenceDate.yearNumber) ?? Date()
                        },
                        label: {
                            ZStack {
                                Circle()
                                    .fill(referenceDate.dayNumber == dayNumber ? Color.red.opacity(0.9) : .clear)
                                    .frame(width: buttonWidth)
                                Text("\(dayNumber)")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(.label))
                            }
                        })
                     })
    }
}

private struct MonthYearPicker: View {
    @ObservedObject var pickerInformation: DatePickerInformation
    var doneAction: () -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if pickerInformation.chooseDay {
                    Button(action: {
                        HapticFeedbackHelper.buttonFeedback()
                        pickerInformation.type = .dayPicker
                    },
                    label: {
                        HStack {
                            Text(pickerInformation.dateFromIndices.monthYearString2)
                                .font(.title3)
                                .foregroundColor(Color(.label))
                                .frame(alignment: .leading)
                            Image(systemName: "chevron.down")
                        }
                    })
                }else {
                    Text(pickerInformation.dateFromIndices.monthYearString2)
                        .font(.title3)
                        .foregroundColor(Color(.label))
                        .frame(alignment: .leading)
                }
                Spacer()
                Button("Done", action: doneAction)
                    .font(.title3)
            }
            Spacer()
            
            HStack {
                Picker("Month", selection: $pickerInformation.monthIndex) {
                    ForEach(0..<pickerInformation.monthNames.count) {
                        Text(pickerInformation.monthNames[$0])
                    }
                }
                .frame(width: 150)
                .clipped()
                .labelsHidden()
                
                Picker("Year", selection: $pickerInformation.yearIndex, content: {
                    ForEach(0..<pickerInformation.yearNames.count) {
                        Text(pickerInformation.yearNames[$0])
                    }
                })
                .labelsHidden()
                .frame(width: 100)
                .clipped()
            }
        }
    }
}
