//
//  HabitAddRemoveView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

struct HabitAddRemoveView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    let cdHabit: CDHabit
    let updateAction: ()->()
    
    var body: some View {
        GeometryReader {geometry in
            HStack(spacing: 20) {
                GeometryReader {geometry in
                    ZStack {
                        Button(action: {
                            HapticFeedbackHelper.buttonFeedback()
                            persistence.deleteEntry(of: cdHabit,
                                                    withDayString: Date().dayMonthYearString)
                        },label:{
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Image(systemName: "minus")
                                .font(.system(size: geometry.size.width * 0.4, weight: .semibold))
                        })
                    }
                }
                
                UpdatingHabitCircleView(cdHabit: cdHabit, circleSize: geometry.size.height, updateAction: updateAction)
            
                GeometryReader {geometry in
                    ZStack {
                        Button(action: {
                            HapticFeedbackHelper.buttonFeedback()
                            persistence.addEntry(to: cdHabit,
                                                 withDayString: Date().dayMonthYearString)
                        },label:{
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Image(systemName: "plus")
                                .font(.system(size: geometry.size.width * 0.4, weight: .semibold))
                        })
                    }
                }
            }
        }
    }
}
