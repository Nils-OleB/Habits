//
//  ChartView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 01.11.20.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var chartInformation: ChartInformation
    var dateButtonAction: (Date.DateComponent) -> (() -> ())
        
    var body: some View {
        VStack(spacing: 10) {
            
            Picker(selection: .init(get: { chartInformation.chartRange },
                                    set: { chartInformation.chartRange = $0}),
                   label: EmptyView()) {
                Text("week").tag(Date.DateComponent.week)
                Text("month").tag(Date.DateComponent.month)
                Text("year").tag(Date.DateComponent.year)
            }
            .onChange(of: chartInformation.chartRange, perform: { _ in
                HapticFeedbackHelper.buttonFeedback()
            })
            .pickerStyle(SegmentedPickerStyle())
            
            
            HStack {
                Button(action: dateButtonAction(chartInformation.chartRange),
                       label: {
                        Text(chartInformation.dateString)
                            .font(.title3)
                            .foregroundColor(Color(.label))
                            .frame(alignment: .leading)
                       })
                Spacer()
            }

            HStack(spacing: 5) {
                VStack(spacing: 0) {
                    YAchsisView(chartInformation: chartInformation)
                        .frame(width: 30)
                    Spacer()
                        .frame(height: 20)
                }
                
                VStack(spacing: 0) {
                    SwipeableGraphView(chartInformation: chartInformation)
                    XAchsisView(chartInformation: chartInformation)
                        .frame(height: 20)
                }
            }
        }
    }
}

fileprivate struct SwipeableGraphView: View {
    @ObservedObject var chartInformation: ChartInformation
    
    var body: some View {
        GeometryReader{ geometry in
            SwipeableView(offset: -geometry.size.width,
                          spacing: 0,
                          swipeLeftAction: {
                            chartInformation.referenceDate = chartInformation.referenceDate.previous(chartInformation.chartRange)
                          },
                          swipeRightAction: {
                            chartInformation.referenceDate = chartInformation.referenceDate.next(chartInformation.chartRange)
                          },
                          background: {() -> InternSwipeView in
                            InternSwipeView(chartInformation: chartInformation, isBackground: true, width: 0, height: 0)
                          },
                          content: { index -> InternSwipeView in
                            let chartInformation: ChartInformation
                            switch index {
                            case 0:
                                chartInformation = ChartInformation(chartRange: self.chartInformation.chartRange,
                                                                    referenceDate: self.chartInformation.referenceDate.previous(self.chartInformation.chartRange),
                                                                    cdHabit: self.chartInformation.cdHabit)
                            case 1:
                                chartInformation = ChartInformation(chartRange: self.chartInformation.chartRange,
                                                                    referenceDate: self.chartInformation.referenceDate,
                                                                    cdHabit: self.chartInformation.cdHabit)
                            case 2:
                                chartInformation = ChartInformation(chartRange: self.chartInformation.chartRange,
                                                                    referenceDate: self.chartInformation.referenceDate.next(self.chartInformation.chartRange),
                                                                    cdHabit: self.chartInformation.cdHabit)
                            default:
                                chartInformation = ChartInformation(chartRange: self.chartInformation.chartRange,
                                                                    referenceDate: self.chartInformation.referenceDate,
                                                                    cdHabit: self.chartInformation.cdHabit)
                            }
                            return InternSwipeView(chartInformation: chartInformation,
                                                   isBackground: false,
                                                   width: geometry.size.width,
                                                   height: geometry.size.height)
                          })
        }
        .border(Color.gray, width: 1)
    }
}

fileprivate struct InternSwipeView: View {
    @ObservedObject var chartInformation: ChartInformation
    let isBackground: Bool
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        if isBackground {
            ZStack {
                Color(UIColor.gray.withAlphaComponent(0.2))
                GraphBackgroundView(chartInformation: chartInformation)
            }
        }else {
            ZStack {
                InternBarView(chartInformation: chartInformation, width: width, height: height)
                GoalBar(chartInformation: chartInformation)
            }
        }
        
    }
}

fileprivate struct GraphBackgroundView: View {
    @ObservedObject var chartInformation: ChartInformation
    let lineWidth: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            let sectionWidth: CGFloat = (geometry.size.width / CGFloat(chartInformation.numberOfXSections))
            let sectionHeight: CGFloat = (geometry.size.height / CGFloat(chartInformation.visibleYValues.count-1))
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<chartInformation.visibleYValues.count-2, id: \.self) { _ in
                        Spacer()
                            .frame(height: sectionHeight - lineWidth)
                        
                        Line(direction: .horizontal)
                            .stroke(style: StrokeStyle(lineWidth: lineWidth))
                            .frame(height: lineWidth)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                        .frame(height: sectionHeight)
                }
                
                HStack(spacing: 0) {
                    ForEach(0..<chartInformation.numberOfXSections - 1, id: \.self) { _ in
                        Spacer()
                            .frame(width: sectionWidth - lineWidth)
                        Line(direction: .vertical)
                            .stroke(style: StrokeStyle(lineWidth: lineWidth))
                            .frame(width: lineWidth)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                        .frame(width: sectionWidth)
                }
            }
        }
    }
}

fileprivate struct GoalBar: View {
    @ObservedObject var chartInformation: ChartInformation
    let lineWidth: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            let sectionHeight: CGFloat = (geometry.size.height / CGFloat(chartInformation.visibleYValues.max() ?? 1))
            let amountAbove = (chartInformation.visibleYValues.max() ?? 1) - Int(chartInformation.cdHabit.goal)
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: lineWidth/2)
                if amountAbove > 0 {
                    Spacer()
                        .frame(height: (sectionHeight * CGFloat(amountAbove)) - lineWidth/2)
                }
                
                Line(direction: .horizontal)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth))
                    .frame(height: lineWidth)
                    .foregroundColor(.red)
                
                Spacer()
            }
        }
    }
}

fileprivate struct InternBarView: View {
    @ObservedObject var chartInformation: ChartInformation
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        let barWidth: CGFloat = width / CGFloat(chartInformation.data.count * 2)
        let maxBarHeight = height
        
        HStack(spacing: 0) {
            Spacer()
                .frame(width: barWidth/2)
            
            ForEach(chartInformation.data.indices, id: \.self) { entryNumber in
                let value = chartInformation.data[entryNumber]
                let barHeight:CGFloat = CGFloat(value) * (maxBarHeight/CGFloat(chartInformation.visibleYValues.last!))
                VStack(spacing: 0) {
                    Spacer()
                        .frame(width: barWidth, height: maxBarHeight-barHeight)
                    
                    Rectangle()
                        .fill(Color(chartInformation.cdHabit.colorID.rawValue))
                        .frame(width: barWidth, height: barHeight)
                        .cornerRadius(barWidth/2)
                }
                if entryNumber < chartInformation.data.count-1 {
                    Spacer()
                        .frame(width: barWidth)
                }
            }
            
            Spacer()
                .frame(width: barWidth/2)
        }
    }
}

fileprivate struct XAchsisView: View {
    @ObservedObject var chartInformation: ChartInformation
    
    var body: some View {
        GeometryReader { geometry in
            let sectionWidth: CGFloat = (geometry.size.width / CGFloat(chartInformation.numberOfXSections))
            let isMonthView = chartInformation.chartRange == .month
            
            HStack(spacing: -sectionWidth) {
                ForEach(0..<chartInformation.chartLabels.count, id: \.self) {
                    Text(chartInformation.chartLabels[$0].uppercased())
                        .font(.footnote)
                        .frame(width: $0 == 0 ? sectionWidth : sectionWidth * 3,
                               alignment: .bottom)
                    
                    Spacer()
                        .frame(width: $0 == 0 ? sectionWidth*2 : sectionWidth)
                    
                    Spacer()
                        .frame(width: isMonthView ? sectionWidth * 4 : 0)
                }
            }
        }
    }
}

fileprivate struct YAchsisView: View {
    @ObservedObject var chartInformation: ChartInformation
    
    var body: some View {
        GeometryReader { geometry in
            let sectionHeight: CGFloat = (geometry.size.height / CGFloat(chartInformation.visibleYValues.count-1))
            VStack(spacing: -sectionHeight / 2) {
                Spacer()
                    .frame(height: 0)
                
                ForEach(chartInformation.visibleYValues.reversed(), id: \.self) { value in
                    Text("\(value)")
                        .font(.footnote)
                        .minimumScaleFactor(0.5)
                        .frame(width: geometry.size.width, height: sectionHeight, alignment: .trailing)
                    
                    Spacer()
                        .frame(height: sectionHeight)
                }
            }
        }
    }
}
