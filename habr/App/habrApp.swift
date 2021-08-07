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
                if #available(iOS 15, *) {
                    OnboardingView_15()
                } else {
                    OnboardingView_14()
                }
            } else {
               ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
