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
    private var monitor: Any?

    init() {
        Logger.log("KeyboardViewModel init", category: .debug)
    }
    
    func start() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            Logger.log("MewmoryApp Keydown: \(event.keyCode)", category: .debug)
            guard let currentKeyStr = event.characters else { return }
            self.currentKey = currentKeyStr
        }
    }
}
