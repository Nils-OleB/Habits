//
//  HabitsApp.swift
//  Habits
//
//  Created by Nils-Ole Bickel on 18.01.21.
//

import SwiftUI

@main
struct HabitsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
                .environmentObject(persistenceController)
        }
    }
}
