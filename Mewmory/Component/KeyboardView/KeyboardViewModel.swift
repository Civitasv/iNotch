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
    var keyString: String = "W"
    var keyCode: Int = 0
    var modifierFlags: NSEvent.ModifierFlags?
    
    var modifierString: String {
        var result = ""
        guard let modifierFlags = modifierFlags else { return result }
        if modifierFlags.contains(.command) {
            result += "Command"
        }
        if modifierFlags.contains(.control) {
            result += " + Ctrl"
        }
        if modifierFlags.contains(.shift) {
            result += " + Shift"
        }
        if modifierFlags.contains(.option) {
            result += " + Option"
        }
        return result
    }
    
    var isTrusted: Bool = AXIsProcessTrusted() // 是否允许访问当前点击的按键
    private var monitor: Any?
    private var specialKeys: [UInt16:String] = [
        126: "⬆️"
    ]

    init() {
        Logger.log("KeyboardViewModel init", category: .debug)
        if isTrusted {
            startMonitoring()
        }
        else {
            acquireAccessibilityPrivileges()
        }
    }

    /// 开始监听
    private func startMonitoring() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            Logger.log("MewmoryApp Keydown: \(event.keyCode)", category: .debug)
            guard let self else { return }
            modifierFlags = event.modifierFlags
            
            if let special = specialKeys[event.keyCode] {
                keyString = special
            }
            else {
                guard let charactersIgnoringModifiers = event.charactersIgnoringModifiers else { return }
                
                keyString = charactersIgnoringModifiers
            }
        }
    }
    
    /// 权限申请
    private func acquireAccessibilityPrivileges() {
        Logger.log("PermissionsGetter.acquireAccessibilityPrivileges", category: .debug)
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let enabled = AXIsProcessTrustedWithOptions(options)
        Logger.log("\(enabled)", category: .debug)
    }
}
