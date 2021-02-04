//
//  HabitCalendarView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 12.01.21.
//

import SwiftUI

struct HabitCalendarView: View {
    @ObservedObject var habitCalendarInformation: HabitCalendarInformation
    var dateButtonAction: () -> ()
    
    var body: some View {
        CalendarView(calendarInformation: habitCalendarInformation.calendarInformation,
                     dateButtonAction: dateButtonAction,
                     content: { dayNumber, buttonWidth, referenceDate in
                        DayCircle(buttonWidth: buttonWidth,
                                  dayNumber: dayNumber,
                                  data: habitCalendarInformation.data(forDate: referenceDate),
                                  color: Color(habitCalendarInformation.cdHabit.colorID.rawValue),
                                  goal: habitCalendarInformation.goal)
                     })
    }
}

private struct DayCircle: View {
    var buttonWidth: CGFloat
    var dayNumber: Int
    var data: [Int]
    var color: Color
    var goal: Int
    
    var body: some View {
        if data.count >= dayNumber {
            ZStack {
                HabitCircleView(circleSize: buttonWidth,
                                habitInformation: HabitInformation(titel: nil,
                                                                   color: color,
                                                                   symbolID: nil,
                                                                   goal: goal,
                                                                   timesDone: data[dayNumber-1],
                                                                   hideProgressNumbers: true))
                Text("\(dayNumber)")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.label))
            }
        }else {
            Spacer()
        }
    }
}
