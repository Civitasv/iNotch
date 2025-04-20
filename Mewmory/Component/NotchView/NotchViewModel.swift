//
//  NotchViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/17.
//

import Foundation
import Defaults
import SwiftUI

let batteryRightComponent = NotchComponent(appType: .Battery) {
    BatteryView()
}
let batteryApp: NotchApp = NotchApp(leftComponent: nil, rightComponent: batteryRightComponent)

let musicLeftComponent = NotchComponent(appType: .Music) {
    MusicLessLeftView()
}
let musicRightComponent = NotchComponent(appType: .Music) {
    MusicLessRightView()
}
let musicApp: NotchApp = NotchApp(leftComponent: musicLeftComponent, rightComponent: musicRightComponent)

let allApps: [NotchAppType: NotchApp] = [
    .Battery : batteryApp,
    .Music : musicApp
] // all apps support by this application

enum NotchAppType {
    case Music
    case Battery
}

struct NotchApp: Identifiable, Equatable {
    let id = UUID()
    let leftComponent: NotchComponent?
    let rightComponent: NotchComponent?
    
    static func == (lhs: NotchApp, rhs: NotchApp) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NotchComponent: Identifiable, Equatable {
    let id = UUID()
    let appType: NotchAppType // 所属应用的标识
    let content: AnyView

    init<Content: View>(
        appType: NotchAppType,
        @ViewBuilder content: () -> Content
   ) {
       self.appType = appType
       self.content = AnyView(content())
   }
    
    static func == (lhs: NotchComponent, rhs: NotchComponent) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NotchSnapShot {
    var leftComponent: NotchComponent? = nil
    var rightComponent: NotchComponent? = nil
}

@Observable
final class NotchViewModel {
    var notchViewSize: CGSize = getClosedNotchSize() // the view size of notch bar
    var bHovering: Bool = false

    var currentSnapShot: NotchSnapShot = NotchSnapShot()
    private var historyRightComponentStack: [NotchComponent] = []

    init() {
        registerEvents()
    }
    
    func registerEvents() {
        Logger.log("RegisterEvents", category: .debug)
        registerEvent(name: "MusicViewModel.CurrentTrack.IsPlaying") { [weak self] userInfo in
            guard let self else { return }
            guard let userInfo = userInfo else {
               return
            }

            guard let isPlaying = userInfo["IsPlaying"] as? Bool else {
               return
            }
            Logger.log("IsPlaying: \(isPlaying)", category: .debug)
            if isPlaying {
                addApp(musicApp)
            }
        }
    }
    
    func isHoveringOnNotch() -> Bool {
        let position: NSPoint = NSEvent.mouseLocation
        if let screen = NSScreen.main {
            let baseX = screen.frame.midX - notchViewSize.width / 2
            let baseY = screen.frame.maxY - notchViewSize.height
            return position.y >= baseY && position.x >= baseX && position.x <= baseX + notchViewSize.width
        }
        return false
    }
    
    func addApp(_ app: NotchApp) {
        if let leftComponent = app.leftComponent {
            if currentSnapShot.leftComponent == nil {
                // 如果此时左边还没有 component，占用左边
                addToLeftSlot(component: leftComponent)
            }
        }
        
        if let rightComponent = app.rightComponent {
            // app的右component存在的话，无论如何都要占用
            addToRightSlot(component: rightComponent)
        }
    }
    
    private func addToLeftSlot(component: NotchComponent) {
        currentSnapShot.leftComponent = component
    }
    
    private func addToRightSlot(component: NotchComponent) {
        pushToRightComponentStack(component: currentSnapShot.rightComponent)
        currentSnapShot.rightComponent = component
    }
    
    private func pushToRightComponentStack(component: NotchComponent?) {
        guard let component else { return }
        historyRightComponentStack.insert(component, at: 0)
    }
    
    private func popFromRightComponentStack() -> NotchComponent? {
        if historyRightComponentStack.count > 0 {
            let component = historyRightComponentStack.remove(at: 0)
            return component
        }
        return nil
    }
    
    func navigate(isForward: Bool) {
        if isForward {
            guard let leftComponent = currentSnapShot.leftComponent else { return }
            let appType = leftComponent.appType
            guard let app = allApps[appType] else { return }
            guard let rightComponent = app.rightComponent else { return }
            // 显示该 app 的右 component
            if rightComponent != currentSnapShot.rightComponent {
                addToRightSlot(component: rightComponent)
            }
        }
        else {
            guard let rightComponent = currentSnapShot.rightComponent else {
                return
            }
            let appType = rightComponent.appType
            guard let app = allApps[appType] else { return }
            guard let leftComponent = app.leftComponent else { return }
            // 显示该 app 的左 component
            if leftComponent != currentSnapShot.leftComponent {
                addToLeftSlot(component: leftComponent)
            }
        }
    }
}
