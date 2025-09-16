//
//  TextForgeApp.swift
//  TextForge
//
//  Created by Joshua Toro on 9/16/25.
//

import SwiftUI
import CoreData

@main
struct TextForgeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
