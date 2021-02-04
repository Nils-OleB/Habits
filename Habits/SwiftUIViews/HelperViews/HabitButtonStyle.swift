//
//  HabitButtonStyle.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 04.02.21.
//

import SwiftUI

struct HabitButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
    }
}
