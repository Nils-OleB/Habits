//
//  SwipeableView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 16.01.21.
//

import SwiftUI

struct SwipeableView<Content: View>: View {
    @State var offset: CGFloat
    @State var index: Int = 1
    let spacing: CGFloat
    
    let swipeLeftAction: () -> ()
    let swipeRightAction: () -> ()
    var backgroundColor: Color? = nil
    var background: (() -> Content)? = nil
    
    let content: (Int) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            return ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: self.spacing) {
                    ForEach(0..<3) { viewNumber in
                        content(viewNumber)
                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .background(
                ZStack {
                    backgroundColor
                    background?()
                }
            )
            .clipped()
            .gesture(
                DragGesture()
                    .onChanged({ value in
//                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2 {
                            self.index -= 1
                        }
                        withAnimation(.easeOut(duration: 0.2)) { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                    })
            )
            .onAnimationCompleted(for: offset, completion: {
                guard offset != -(geometry.size.width + self.spacing) else {return}
                
                if index == 0 {
                    swipeLeftAction()
                }else {
                    swipeRightAction()
                }
 
                self.index = 1
                self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index)
            })
        }
    }
}
