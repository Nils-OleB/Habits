//
//  CalendarView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

struct CalendarView<Content: View>: View {
    @ObservedObject var calendarInformation: CalendarInformation
    var dateButtonAction: () -> ()
    var doneAction: (() -> ())? = nil
    var backgroundColor: Color? = nil
    let content: (Int, CGFloat, Date) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Button(action: dateButtonAction,
                           label: {
                            HStack {
                                Text(calendarInformation.referenceDate.monthYearString2)
                                    .font(.title3)
                                    .foregroundColor(Color(.label))
                                    .frame(alignment: .leading)
                                
                                if calendarInformation.buttonArrowActive {
                                    Image(systemName: "chevron.right")
                                        .animation(nil)
                                }
                            }
                           })
                    Spacer()
                    if let doneAction = doneAction {
                        Button("done", action: doneAction)
                            .font(.title3)
                    }
                }
                
                Spacer()
                HStack {
                    ForEach(Date.shortWeekdayArray, id: \.self) { dayName in
                        Text(dayName.uppercased())
                            .frame(width:(geometry.size.width/7) ,alignment: .center)
                            .font(.footnote)
                        if dayName != Date.shortWeekdayArray.last {
                            Spacer(minLength: 0)
                        }
                    }
                }
                CalendarSwipeView(calendarInformation: calendarInformation,
                                  backgroundColor: backgroundColor,
                                  content: { dayNumber, buttonWidth, referenceDate in
                                    content(dayNumber, buttonWidth, referenceDate)
                                  })
            }
        }
    }
}

private struct CalendarSwipeView<Content: View>: View {
    @ObservedObject var calendarInformation: CalendarInformation
    
    var backgroundColor: Color? = nil
    let content: (Int, CGFloat, Date) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            SwipeableView(offset: -(geometry.size.width + 20),
                          spacing: 20,
                          swipeLeftAction: {
                            calendarInformation.referenceDate = calendarInformation.referenceDate.previous(.month)
                          },
                          swipeRightAction: {
                            calendarInformation.referenceDate = calendarInformation.referenceDate.next(.month)
                          },
                          backgroundColor: backgroundColor) { index -> CalendarMonthView<Content> in
                let viewWidth = geometry.size.width
                let viewHeight = geometry.size.height * 0.9
                
                let calendarInformation: CalendarInformation
                
                switch(index) {
                case 0:
                    calendarInformation = CalendarInformation(date: self.calendarInformation.referenceDate.previous(.month),
                                                              buttonArrowActive: self.calendarInformation.buttonArrowActive)
                case 1:
                    calendarInformation = CalendarInformation(date: self.calendarInformation.referenceDate,
                                                              buttonArrowActive: self.calendarInformation.buttonArrowActive)
                case 2:
                    calendarInformation = CalendarInformation(date: self.calendarInformation.referenceDate.next(.month),
                                                              buttonArrowActive: self.calendarInformation.buttonArrowActive)
                default:
                    calendarInformation = CalendarInformation(date: self.calendarInformation.referenceDate,
                                                              buttonArrowActive: self.calendarInformation.buttonArrowActive)
                }
                
                return CalendarMonthView(width: viewWidth,
                                         height: viewHeight,
                                         calendarInformation: calendarInformation,
                                         content: { dayNumber in
                                            content(dayNumber, min(viewWidth/7, viewHeight/7), calendarInformation.referenceDate)
                                         })
                
            }
        }
    }
}

private struct CalendarMonthView<Content: View>: View {
    var width: CGFloat
    var height: CGFloat
    @ObservedObject var calendarInformation: CalendarInformation
    
    let content: (Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<6) { rowNum in
                HStack(spacing: 0) {
                    ForEach(0..<7) { colNum in
                        if let dayNumber = calendarInformation.getDayNumber(forRow: rowNum, column: colNum) {
                            content(dayNumber)
                                .frame(width:(width/7) ,alignment: .center)
                        }else {
                            Spacer()
                                .frame(width:(width/7))
                        }
                        
                        if colNum != 6 {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(height: height/7)
            }
        }
        .frame(height: height*1.1)
    }
}
