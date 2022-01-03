//
//  QuickActions.swift
//  QuickActions
//
//  Created by Anton Krivonozhenkov on 20.08.2021.
//

// https://www.youtube.com/watch?v=kLDiCDnN8wQ

import Foundation
import SwiftUI

struct QuickAction: Hashable {
    var type: String
    var title: String
    var subtitle: String
    var icon: String
    
    func quickAction() -> UIApplicationShortcutItem {
        return UIApplicationShortcutItem(type: self.type, localizedTitle: self.title, localizedSubtitle: self.subtitle, icon: .init(systemImageName: self.icon), userInfo: ["type": self.type as NSSecureCoding])
    }
}

enum ActionTypes: CaseIterable {
  //  case dynamicOne
    case staticOne
    case staticTwo
    
    var instance: QuickAction {
        switch self {
//        case .dynamicOne:
//            return QuickAction(type: "dynamic1", title: "First Dynamic", subtitle: "1st dynamic action", icon: "1.square")
        case .staticOne:
            return QuickAction(type: "static1", title: "First Action", subtitle: "This will do one thing", icon: "1.circle")
        case .staticTwo:
            return QuickAction(type: "static2", title: "Second Action", subtitle: "This will do second thing", icon: "1.circle")
        }
        
    }
}

//let AllDynamicActions: [QuickAction] = [ActionTypes.dynamicOne.instance]

func getAction(_ typeString: String) -> QuickAction? {
    if let action = ActionTypes.allCases.first(where: { $0.instance.type == typeString}) {
        return action.instance
    } else {
        return nil
    }
}

class QuickActionObservable: ObservableObject {
    @Published var selectedAction: QuickAction? = nil
}
