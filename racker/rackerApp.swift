//
//  rackerApp.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import SwiftUI

@main
struct rackerApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
