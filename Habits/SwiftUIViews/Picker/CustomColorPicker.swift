//
//  CustomColorPicker.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct CustomColorPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: ColorHelper.ColorID
    
    var body: some View {
        let colorIDs = ColorHelper.colorNames
        
        let columns = [ GridItem(.adaptive(minimum: 60)) ]
        
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(colorIDs, id: \.self){ colorID in
                    ZStack {
                        Circle()
                            .fill(Color(colorID.rawValue))
                            .frame(width: 50, height: 50)
                            .onTapGesture(perform: {
                                HapticFeedbackHelper.buttonFeedback()
                                selection = colorID
                                presentationMode.wrappedValue.dismiss()
                            })
                            .padding(10)
                        
                        if selection == colorID {
                            Circle()
                                .stroke(Color(colorID.rawValue), lineWidth: 5)
                                .frame(width: 60, height: 60)
                        }
                    }
                }
            }
            .padding(10)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
        
    }
}
