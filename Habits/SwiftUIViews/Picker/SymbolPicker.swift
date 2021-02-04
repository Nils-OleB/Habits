//
//  SymbolPicker.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct SymbolPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: SymbolHelper.SymbolID
    
    let color: Color
    
    var body: some View {
        let symbolIDs = SymbolHelper.symbols
        
        let columns = [ GridItem(.adaptive(minimum: 60)) ]
        
        VStack {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(symbolIDs, id: \.self){ symbolID in
                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .onTapGesture(perform: {
                                HapticFeedbackHelper.buttonFeedback()
                                selection = symbolID
                                presentationMode.wrappedValue.dismiss()
                            })
                            .padding(10)
                        
                        Image(systemName: symbolID.rawValue)
                            .font(.system(size: 25, weight: .semibold))
                        
                        if selection == symbolID {
                            Circle()
                                .stroke(color, lineWidth: 5)
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
