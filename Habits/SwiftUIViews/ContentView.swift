//
//  ContentView.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject private var persistence: PersistenceController
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            HabitHomeView()
                .tabItem {
                    Image(systemName: "calendar")
                        .foregroundColor(Color(.label))
                    
                }
            
            NewHabitView()
                .tabItem {
                    Image(systemName: "plus")
                        .foregroundColor(Color(.label))
                }
            
            HabitDetailListView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                }
        }
        .accentColor(.habitsPrimaryColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ContentView()
//                .preferredColorScheme(.dark)
            
//                .previewDevice("iPhone 12 Pro")
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//
//            ContentView()
//                .preferredColorScheme(.light)
//                .previewDevice("iPhone 12 Pro")
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
            
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12 mini")
                .environment(\.managedObjectContext, PersistenceController.preview.viewContext)
        }
    }
}
