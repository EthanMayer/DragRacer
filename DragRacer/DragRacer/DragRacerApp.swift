//
//  DragRacerApp.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/23/23.
//

import SwiftUI

@main
struct DragRacerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
