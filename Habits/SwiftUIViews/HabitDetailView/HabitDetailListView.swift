//
//  HabitDetailListView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

struct HabitDetailListView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: CDHabit.getAllCDHabits()) var cdHabits: FetchedResults<CDHabit>
    
    @State private var isShowingDetailView = false
    @State private var selectedCDHabit: CDHabit?
    
    var body: some View {
        NavigationView {
            VStack {
                if let selectedCDHabit = selectedCDHabit {
                    NavigationLink(destination: HabitDetailView(cdHabit: selectedCDHabit,
                                                                updateAction: {
                                                                    persistence.addEntry(to: selectedCDHabit,
                                                                                         withDayString: Date().dayMonthYearString)
                                                                }),
                                   isActive: $isShowingDetailView) { EmptyView() }
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible())],
                              spacing: 10,
                              content: {
                                ForEach(cdHabits, id: \.self) { cdHabit in
                                    HabitDetailsListItem(cdHabit: cdHabit as CDHabit, updateAction: {
                                        persistence.addEntry(to: cdHabit,
                                                             withDayString: Date().dayMonthYearString)
                                    })
                                        .onTapGesture {
                                            HapticFeedbackHelper.buttonFeedback()
                                            selectedCDHabit = cdHabit as CDHabit
                                            isShowingDetailView = true
                                        }
                                }
                              })
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

private struct HabitDetailsListItem: View {
    let cdHabit: CDHabit
    let updateAction: () -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(cdHabit.colorID.rawValue).opacity(0.3))
                .frame(height: 90)
                .cornerRadius(10)
            
            HStack(spacing: 10) {
                UpdatingHabitCircleView(cdHabit: cdHabit, circleSize: 70, updateAction: updateAction)
                Text(cdHabit.titel ?? "")
                    .font(.title)
                    .bold()
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .opacity(0.5)
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .animation(nil)
    }
    
}

struct HabitDetailListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDetailListView()
    }
}
