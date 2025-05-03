//
//  iNotchApp.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/13.
//

import AVFoundation
import Combine
import SwiftUI
import Defaults

@main
struct iNotchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openWindow) var openWindow
    
    var body: some Scene {
        Window("iNotch", id: "iNotch") {
            NotchView()
        }
        .windowStyle(.hiddenTitleBar)
        
        MenuBarExtra("iNotch", systemImage: "arrow.trianglehead.counterclockwise") {
            Button("Settings") {
                openWindow(id: "iNotch") // 通过 id 打开对应窗口
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding()
        }
        .menuBarExtraStyle(.window)
    }
    
    init() {
        Logger.log("iNotch Init", category: .ui)
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
