//
//  HabitDailyCircleView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct HabitDailyCircleView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: CDHabit.getAllCDHabits()) var cdHabits: FetchedResults<CDHabit>
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                let squareSize = min(geometry.size.height, geometry.size.width)
                
                let numberOfHabits = cdHabits.isEmpty ? 0 : cdHabits.count > 8 ? 8 : cdHabits.count
                
                
                let circleSize = getCircleSize(squareSize: squareSize, numberOfHabits: numberOfHabits)
                let padding = circleSize * 0.65
                
                ForEach(cdHabits) { cdHabit in
                    if cdHabit.position <= 8 {
                        let habitIndex = cdHabits.firstIndex(of: cdHabit) ?? 0
                        let (x, y) = getPosition(number: habitIndex, viewSize: geometry.size, numberOfButtons: numberOfHabits, padding: padding)
                        
                        HabitButton(circleSize: circleSize,
                                    cdHabit: cdHabit,
                                    action: {
                                        persistence.addEntry(to: cdHabit,
                                                             withDayString: Date().dayMonthYearString)
                                    })
                            .position(x: x, y: y)
                    }
                }
                
            }.frame(maxWidth: .infinity)
        }
    }
    
    private func getCircleSize(squareSize: CGFloat,
                               numberOfHabits: Int) -> CGFloat {
        var circleSize: CGFloat = 0
        switch numberOfHabits {
        case 1:
            circleSize = squareSize * 0.9
        case 2:
            circleSize = squareSize * 0.42
        case 3:
            circleSize = squareSize * 0.4
        case 4:
            circleSize = squareSize * 0.35
        case 5:
            circleSize = squareSize * 0.31
        case 6:
            circleSize = squareSize * 0.28
        case 7:
            circleSize = squareSize * 0.26
        case 8:
            circleSize = squareSize * 0.24
        default:
            circleSize = squareSize * 0.24
            
        }
        return circleSize
    }
    
    private func getPosition(number: Int,
                             viewSize: CGSize,
                             numberOfButtons: Int,
                             padding: CGFloat) -> (CGFloat, CGFloat) {
        
        let squareSize = min(viewSize.height, viewSize.width)
        let center = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        let radius: CGFloat = (squareSize / 2) - padding
        let count = numberOfButtons
                
        let pi = Double.pi
        var angle = CGFloat(1.5 * pi)
        let step = CGFloat(2 *  pi) / CGFloat(count)
        
        angle += CGFloat(number) * step
        
        let x = cos(angle) * radius + center.x
        let y = sin(angle) * radius + center.y
        
        if numberOfButtons == 1 {
            return (center.x, center.y)
        }
        return (x,y)
    }
}

struct HabitDailyCircleView_Previews: PreviewProvider {
    static var previews: some View {
        HabitDailyCircleView()
    }
}
