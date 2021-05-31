//
//  habrApp.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

@main
struct habrApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding{
                OnboardingView()
            } else {
               ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
