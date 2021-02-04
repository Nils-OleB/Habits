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
            StreakCircleView(text: "Goals \nmet",
                             number: 5000)
            StreakCircleView(text: "Current \nstreak",
                             number: 50)
            StreakCircleView(text: "Longest \nstreak",
                             number: 500)
        }
    }
}

private struct StreakCircleView: View {
    var text: String
    var number: Int
    
    var body: some View {
        VStack {
            Text(text.uppercased())
                .font(.footnote)
            
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
