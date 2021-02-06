//
//  HabitHomeView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct HabitHomeView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        GeometryReader{ geometry in
            let circleSize = min(geometry.size.height - 40, geometry.size.width - 40)
            
            NavigationView {
                ScrollView {
                    VStack(spacing: 10) {
                        HabitHomeCardView(circleSize: circleSize,
                                          goalPeriod: .daily)
                        
                        HabitHomeCardView(circleSize: circleSize,
                                          goalPeriod: .weekly)
                        
                        HabitHomeCardView(circleSize: circleSize,
                                          goalPeriod: .monthly)
                        
                        HabitHomeCardView(circleSize: circleSize,
                                          goalPeriod: .yearly)
                        
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                }
//                .navigationTitle("Home")//Date().dayMonthYearString3)
            }
        }
    }
}

struct HabitHomeCardView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: CDHabit.getAllCDHabits()) var cdHabits: FetchedResults<CDHabit>
    
    let circleSize: CGFloat
    let goalPeriod: GoalPeriodHelper.GoalPeriodID
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            VStack {
                HStack {
                    Text(getTitleString())
                        .font(.title)
                        .bold()
                    Spacer()
                }
                
                Line(direction: .horizontal)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .frame(height: 1)
                    .foregroundColor(.habitsPrimaryColor)
                
                HabitDailyCircleView()
                    .frame(height: circleSize)
                
                if cdHabits.count > 8 {
                    Line(direction: .horizontal)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(height: 1)
                        .foregroundColor(.habitsPrimaryColor)
                    
                    Spacer()
                    
                    HabitListView()
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
    }
    
    func getTitleString() -> String {
        switch goalPeriod {
        case .daily:
            return "TODAY"
//            return Date().dayMonthYearString3
        case .weekly:
            return "THIS WEEK"
//            return Date().weekString
        case .monthly:
            return "THIS MONTH"
//            return Date().monthYearString2
        case .yearly:
            return "THIS YEAR"
//            return Date().yearString
        }
    }
}

struct HabitHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HabitHomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
            .environmentObject(PersistenceController.preview)
    }
}
