//
//  HabitCircleSwiftUIView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.11.20.
//

import SwiftUI

struct HabitInformation {
    let titel: String?
    let color: Color
    let symbolID: SymbolHelper.SymbolID?
    let goal: Int
    let timesDone: Int
    
    let hideProgressNumbers: Bool
    
    var percentageDone: CGFloat {
        return CGFloat(timesDone) / CGFloat(goal)
    }
}

struct UpdatingHabitCircleView: View {
    @ObservedObject var dayInformation = DayInformation.shared
    let cdHabit: CDHabit
    let circleSize: CGFloat
    
    let updateAction: () -> ()
    
    var body: some View {
        let habitInformation = HabitInformation(titel: cdHabit.titel,
                                                color: Color(cdHabit.colorID.rawValue),
                                                symbolID: cdHabit.symbolID,
                                                goal: Int(cdHabit.goal),
                                                timesDone: cdHabit.numberFor(dayString: dayInformation.dayString),
                                                hideProgressNumbers: false)

        HabitCircleView(circleSize: circleSize,
                        habitInformation: habitInformation)
            .animation(.easeInOut)
    }
    
}

struct HabitCircleView: View {
    let circleSize: CGFloat
    let habitInformation: HabitInformation
    
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
