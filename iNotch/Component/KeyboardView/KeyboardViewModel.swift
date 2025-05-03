//
//  KeyboardViewModel.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/15.
//

import Foundation
import SwiftUI
import Defaults

@Observable
final class KeyboardViewModel {
    var keyString: String = "W"
    var keyCode: Int = 0
    var modifierFlags: NSEvent.ModifierFlags?
    
    var modifierString: String {
        var result = ""
        guard let modifierFlags = modifierFlags else { return result }
        if modifierFlags.contains(.command) {
            result += "⌘"
        }
        if modifierFlags.contains(.control) {
            result += "⌃"
        }
        if modifierFlags.contains(.shift) {
            result += "⇧"
        }
        if modifierFlags.contains(.option) {
            result += "⌥"
        }
        return result
    }
    
    var isTrusted: Bool = AXIsProcessTrusted() // 是否允许访问当前点击的按键
    private var monitor: Any?
    private var specialKeys: [UInt16:String] = [
        126: "↑",
        125: "↓",
        124: "→",
        123: "←",
        48: "⇥",
        53: "⎋",
        71: "⌧",
        51: "⌫",
        117: "⌦",
        114: "⃝",
        115: "↖",
        119: "↘",
        116: "⇞",
        121: "⇟",
        36: "↩",
        76: "↩",
        145: "🔅",
        144: "🔆",
        160: "<>",
        131: "🚀",
        177: "🔍",
        176: "🎤",
        178: "⏾",
        49: "␣",
        179: "fn",
        122: "F1",
        120: "F2",
        99: "F3",
        118: "F4",
        96: "F5",
        97: "F6",
        98: "F7",
        100: "F8",
        101: "F9",
        109: "F10",
        103: "F11",
        111: "F12",
        105: "F13",
        107: "F14",
        113: "F15",
        106: "F16",
        64: "F17",
        79: "F18",
        80: "F19",
        90: "F20"
    ]

    init() {
        Logger.log("KeyboardViewModel init", category: .debug)
        if !Defaults[.featureSystem] {
            return
        }
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
//            Logger.log("iNotchApp Keydown: \(event.keyCode)", category: .debug)
            guard let self else { return }
            modifierFlags = event.modifierFlags
            
            if let special = specialKeys[event.keyCode] {
                keyString = special
            }
            else {
                guard let charactersIgnoringModifiers = event.charactersIgnoringModifiers else { return }
                
                keyString = charactersIgnoringModifiers
            }
            postEvent(name: "KeyboardViewModel.IsPressKey", params: ["IsPressKey": true])
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { event in
            postEvent(name: "KeyboardViewModel.IsPressKey", params: ["IsPressKey": false])
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
