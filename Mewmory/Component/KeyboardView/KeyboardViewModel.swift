//
//  KeyboardViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/15.
//

import Foundation
import SwiftUI
  
@Observable
final class KeyboardViewModel {
    var currentKey: String = ""
    var modifier: String = ""
    private var monitor: Any?

    init() {
        Logger.log("KeyboardViewModel init", category: .debug)
    }
    
    func start() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            Logger.log("MewmoryApp Keydown: \(event.keyCode)", category: .debug)
            guard let currentKeyStr = event.characters else { return }
            self.currentKey = currentKeyStr
//            self.modifier = event.modifierFlags
        }
    }
    
    func translateModifierFlag() {
        
    }
    
    func build() -> String {
        return "\(modifier) + \(currentKey)"
    }
    
    func acquireAccessibilityPrivileges() {
        Logger.log("PermissionsGetter.acquireAccessibilityPrivileges", category: .debug)
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let enabled = AXIsProcessTrustedWithOptions(options)
        Logger.log("\(enabled)", category: .debug)
    }
}
