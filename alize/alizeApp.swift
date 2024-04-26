//
//  alizeApp.swift
//  alize
//
//  Created by Julien Delferiere on 24/03/2024.
//

import SwiftUI
import SwiftData

@main
struct alizeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RootViewRepresentable()
        }
        .modelContainer(sharedModelContainer)
    }
}
