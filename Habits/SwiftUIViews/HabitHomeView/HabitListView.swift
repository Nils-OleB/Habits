//
//  HabitListView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.01.21.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: CDHabit.getAllCDHabits()) var cdHabits: FetchedResults<CDHabit>
    
    let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 60))
        ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(cdHabits) { cdHabit in
                if cdHabit.position > 8 {
                    HabitButton(circleSize: 60,
                                cdHabit: cdHabit,
                                action: {
                                    persistence.addEntry(to: cdHabit,
                                                         withDayString: Date().dayMonthYearString)
                                })
                }
            }
        }
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView()
            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
    }
}
