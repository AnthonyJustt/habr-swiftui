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
    
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let quickActionObservable = QuickActionObservable()
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding{
                if #available(iOS 15, *) {
                    OnboardingView_15()
                } else {
                    OnboardingView_14()
                }
            } else {
                ContentView_v2()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(quickActionObservable)
            }
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active :
                print("App in active")
                guard let type = shortcutItemToProcess?.userInfo?["type"] as? String else {
                    return
                }
                quickActionObservable.selectedAction = getAction(type)
                print(type)
            case .inactive:
                // inactive
                print("App is inactive")
            case .background:
                print("App in Back ground")
                let shortcutItems = UIApplication.shared.shortcutItems ?? []
//                if shortcutItems.isEmpty {
//                    for action in AllDynamicActions {
//                        shortcutItems.append(action.quickAction())
//                    }
//                } else {
//                    shortcutItems[0] = ActionTypes.dynamicOne.instance.quickAction()
//                }
                UIApplication.shared.shortcutItems = shortcutItems
            @unknown default:
                print("default")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        return sceneConfiguration
    }
}

class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
}


var shortcutItemToProcess: UIApplicationShortcutItem?
