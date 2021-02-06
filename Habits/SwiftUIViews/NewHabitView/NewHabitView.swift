//
//  NewHabitView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 19.01.21.
//

import SwiftUI

struct NewHabitView: View {
//    @EnvironmentObject private var persistence: PersistenceController
//    @Environment(\.managedObjectContext) private var viewContext
    @State private var editHabitViewVisible = false
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            
            VStack {
                Spacer()
                    .frame(height: 20)
                
                Button(action: {
                    editHabitViewVisible = true
                },
                label: {
                    GeometryReader { geometry in
                        Text("create custom habit")
                            .padding()
                            .frame(width: geometry.size.width, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color(.label))
                            .minimumScaleFactor(0.5)
                    }
                })
                .fullScreenCover(isPresented: $editHabitViewVisible,
                                 content: {
                                    EditHabitView()
                                 })
            }
            
            Spacer()
                .frame(width: 20)
        }
    }
}

struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView()
    }
}
