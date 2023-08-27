//
//  AppleMapsFirstProjectApp.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI

@main
struct AppleMapsFirstProjectApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        TripData.shared.tripState = .none
    }
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
