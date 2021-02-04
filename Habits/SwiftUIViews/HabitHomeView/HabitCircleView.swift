//
//  HabitCircleView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 04.02.21.
//

import SwiftUI

struct HabitCircleView: View {
    let circleSize: CGFloat
    @ObservedObject var habitInformation: HabitInformation
    
    var body: some View {
        let color = habitInformation.color
        let percentageDone = habitInformation.percentageDone
        
        ZStack {
            Circle()
                .trim(from: 0,
                      to: CGFloat(min(percentageDone ,1)))
                .stroke(color, lineWidth: circleSize/2)
                .frame(width: circleSize/2, height: circleSize/2)
                .rotationEffect(Angle(degrees: 270))
            
            Circle()
                .stroke(color, lineWidth: circleSize / 10)
                .frame(width: circleSize, height: circleSize)
            
            VStack {
                if let symbolID = habitInformation.symbolID {
                    Image(systemName: symbolID.rawValue)
                        .font(.system(size: circleSize * 0.4, weight: .semibold))
                        .foregroundColor(Color(.label))
                }else if let titel = habitInformation.titel {
                    Text(titel)
                        .font(.system(size: circleSize * 0.75, weight: .semibold))
                        .foregroundColor(Color(.label))
                }
                if !habitInformation.hideProgressNumbers {
                    Text("\(habitInformation.timesDone)/\(habitInformation.goal)")
                        .font(.system(size: circleSize * 0.2, weight: .semibold))
                        .foregroundColor(Color(.label))
                }
            }
        }
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
