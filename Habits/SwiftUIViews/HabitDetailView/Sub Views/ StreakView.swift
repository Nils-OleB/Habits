//
//  StreakView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

struct StreakView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    let cdHabit: CDHabit
    
    var body: some View {
        HStack {
            StreakCircleView(text: "goals met",
                             number: 5000)
            StreakCircleView(text: "current streak",
                             number: 50)
            StreakCircleView(text: "longest streak",
                             number: 500)
        }
    }
}

private struct StreakCircleView: View {
    var text: LocalizedStringKey
    var number: Int
    
    var body: some View {
        VStack {
            Text(text)
                .font(.footnote)
                .textCase(.uppercase)
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                
                Text("\(number)")
                    .font(.system(size: 500, weight: .semibold))
                    .minimumScaleFactor(0.01)
                    .padding()
                    .lineLimit(1)
            }
        }
    }
}
