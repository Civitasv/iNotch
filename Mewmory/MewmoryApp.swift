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
    @State private var keyboardVm = KeyboardViewModel()
    @State private var cpuVm = CPUViewModel()
    @State private var permissionVm = PermissionsViewModel()

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .frame(width: 0, height: 0)
        }
        .windowStyle(.hiddenTitleBar)
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                Logger.log("MewmoryApp ScenePhase Background", category: .ui)
            case .active:
                Logger.log("MewmoryApp ScenePhase Active", category: .ui)
            case .inactive:
                Logger.log("MewmoryApp ScenePhase InActive", category: .ui)
            @unknown default:
                Logger.log("MewmoryApp ScenePhase Unknown", category: .ui)
            }
        }
        
        MenuBarExtra("Mewmory", systemImage: "pawprint") {
            VStack {
                KeyboardView()
                    .environment(keyboardVm)
                    .environment(permissionVm)
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
        PermissionsViewModel.acquireAccessibilityPrivileges()
    }
}
