//
//  MewmoryApp.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/13.
//

import AVFoundation
import Combine
import SwiftUI
import Defaults

@main
struct MewmoryApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        Window("iNotch", id: "iNotch") {
            NotchView()
        }
        .windowStyle(.hiddenTitleBar)
//        .windowResizability(.contentSize)
        
        MenuBarExtra("Mewmory", systemImage: "pawprint") {
            VStack {
//                KeyboardView()
            }
            .padding()
        }
        .menuBarExtraStyle(.window)
    }
    
    init() {
        Logger.log("MewmoryApp Init", category: .ui)
    }
    
    public func setData() -> Int {
        return 0
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Logger.log("Apply Accessibility Privileges", category: .ui)
    }
}
