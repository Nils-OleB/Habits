//
//  HabitButtonSwiftUIView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.11.20.
//

import SwiftUI

class DayInformation: ObservableObject {
    static let shared = DayInformation()
    private init() {}
    @Published var dayString = Date().dayMonthYearString
}

struct HabitButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct HabitButton: View {
    @ObservedObject var dayInformation = DayInformation.shared
    let circleSize: CGFloat
    let cdHabit: CDHabit
    let action: ()->()

    var body: some View {
        let habitInformation = HabitInformation(titel: cdHabit.titel,
                                                color: Color(cdHabit.colorID.rawValue),
                                                symbolID: cdHabit.symbolID,
                                                goal: Int(cdHabit.goal),
                                                timesDone: cdHabit.numberFor(dayString: dayInformation.dayString),
                                                hideProgressNumbers: false)

        Button(action: {
            #if !os(watchOS)
            HapticFeedbackHelper.buttonFeedback()
            #endif
            action()
        }, label: {
            HabitCircleView(circleSize: circleSize, habitInformation: habitInformation)
                .animation(.easeInOut)
        })
        .frame(width: circleSize, height: circleSize, alignment: .center)
        .cornerRadius(circleSize/2)
        .buttonStyle(HabitButtonStyle())
        .animation(.easeInOut)
    }
}
