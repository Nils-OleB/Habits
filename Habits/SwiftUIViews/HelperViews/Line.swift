//
//  Line.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 21.01.21.
//

import SwiftUI

struct Line: Shape {
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        switch direction {
        case .vertical:
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        case .horizontal:
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
        return path
    }
    
    enum Direction {
        case vertical, horizontal
    }
}
