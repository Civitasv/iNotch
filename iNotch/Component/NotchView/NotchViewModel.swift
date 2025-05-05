//
//  NotchViewModel.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/17.
//

import Foundation
import Defaults
import SwiftUI
import Combine
import Carbon
import AppleScriptObjC

// 灵动岛显示模式，分为隐藏、较少显示、更多显示
enum NotchDisplayMode: Int {
    case Hide = 0
    case Less = 1
    case More = 2
}

enum NotchAppType {
    case Music
}

struct NotchApp: Identifiable, Equatable {
    let id = UUID()
    let leftComponent: NotchComponent?
    let rightComponent: NotchComponent?
    let fullComponent: NotchComponent?

    static func == (lhs: NotchApp, rhs: NotchApp) -> Bool {
        return lhs.id == rhs.id
    }
}

enum NotchTipType {
    case Battery
}

struct NotchTip: Identifiable, Equatable {
    let id = UUID()
    let leftComponent: NotchComponent?
    let rightComponent: NotchComponent?
    let fullComponent: NotchComponent?
    let duration: Double

    static func == (lhs: NotchTip, rhs: NotchTip) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NotchComponent: Identifiable, Equatable {
    let id = UUID()
    let appType: NotchAppType? // 所属应用的标识
    let tipType: NotchTipType? // 所属tips的标识
    let content: AnyView

    init<Content: View>(
        appType: NotchAppType,
        @ViewBuilder content: () -> Content
   ) {
       self.appType = appType
       self.tipType = nil
       self.content = AnyView(content())
   }

    init<Content: View>(
        tipType: NotchTipType,
        @ViewBuilder content: () -> Content
   ) {
       self.appType = nil
       self.tipType = tipType
       self.content = AnyView(content())
   }

    static func == (lhs: NotchComponent, rhs: NotchComponent) -> Bool {
        return lhs.id == rhs.id
    }
}

struct NotchSnapShot {
    var leftComponent: NotchComponent? = nil
    var rightComponent: NotchComponent? = nil
    var fullComponent: NotchComponent? = nil
}

let musicLeftComponent = NotchComponent(appType: .Music) {
    MusicLessLeftView()
}
let musicRightComponent = NotchComponent(appType: .Music) {
    MusicLessRightView()
}
let musicFullComponent = NotchComponent(appType: .Music) {
    MusicMoreView()
}
let musicApp: NotchApp = NotchApp(leftComponent: musicLeftComponent, rightComponent: musicRightComponent, fullComponent: musicFullComponent)

let allApps: [NotchAppType: NotchApp] = [
    .Music : musicApp
] // all apps support by this application


let batteryRightComponent = NotchComponent(tipType: .Battery) {
    BatteryView()
}
let batteryTip: NotchTip = NotchTip(leftComponent: nil, rightComponent: batteryRightComponent, fullComponent: nil, duration: 2.0)

let allTips: [NotchTipType: NotchTip] = [
    .Battery : batteryTip,
] // all tips support by this application

@Observable
final class NotchViewModel {
    var notchViewSize: CGSize = getClosedNotchSize() // the view size of notch bar
    var bHovering: Bool = false
    var displayMode: NotchDisplayMode = .Hide

    var tips: String = ""
    var showTips: Bool = false
    private var tipPanelHideTimer: Timer?
    var showKeyPanel: Bool = false
    private var keyPanelHideTimer: Timer?

    var showVolume: Bool = false
    private var volumeHideTimer: Timer?

    var currentSnapShot: NotchSnapShot = NotchSnapShot()

    private var reachMore: Bool = false
    private var notchSize: CGSize = getClosedNotchSize()
    private var notchPanelRect: CGRect = CGRect(x: 0, y: 0, width: 610, height: 200)

    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    private var cancellables = Set<AnyCancellable>()

    init() {
        registerEvents()
    }

    func registerEvents() {
        Logger.log("RegisterEvents", category: .debug)
        timer.receive(on: DispatchQueue.main)
            .sink { _ in
                postEvent(name: "iNotchApp.Tick", params: nil)
            }
            .store(in: &cancellables)

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

        registerEvent(name: "KeyboardViewModel.IsPressKey") { [weak self] userInfo in
            guard let self else { return }
            guard let userInfo = userInfo else {
               return
            }

            guard let isPressKey = userInfo["IsPressKey"] as? Bool else {
               return
            }
//            Logger.log("IsPressKey: \(isPressKey)", category: .debug)
            keyPanelHideTimer?.invalidate()

            if isPressKey {
                if !showKeyPanel {
                    showKeyPanel = true
                    refreshSize()
                }
            }
            else {
                keyPanelHideTimer = Timer.scheduledTimer(
                    withTimeInterval: 2.0,
                    repeats: false
                ) { [weak self] _ in
                    self?.showKeyPanel = false
                    self?.refreshSize()
                }
            }
        }

        registerEvent(name: "NotchViewModel.ShowTips") { [weak self] userInfo in
            guard let self else { return }
            guard let userInfo = userInfo else {
               return
            }

            guard let tips = userInfo["Tips"] as? String else {
               return
            }
            Logger.log("Tips: \(tips)", category: .debug)
            tipPanelHideTimer?.invalidate()

            self.tips = tips
            if !showTips {
                showTips = true
                refreshSize()
            }

            tipPanelHideTimer = Timer.scheduledTimer(
                withTimeInterval: 5.0,
                repeats: false
            ) { [weak self] _ in
                self?.showTips = false
                self?.refreshSize()
            }
        }

        registerEvent(name: "SoundAdjustingViewModel.VolumeChange") { [weak self] userInfo in
            guard let self else { return }
            guard let userInfo = userInfo else {
               return
            }

            guard let volume = userInfo["Volume"] as? Float else {
               return
            }
            Logger.log("Volume: \(volume)", category: .debug)
            volumeHideTimer?.invalidate()

            if !showVolume {
                showVolume = true
                refreshSize()
            }

            volumeHideTimer = Timer.scheduledTimer(
                withTimeInterval: 5.0,
                repeats: false
            ) { [weak self] _ in
                self?.showVolume = false
                self?.refreshSize()
            }
        }

        // Defaults key change
        Task {
            for await value in Defaults.updates(.featureMusic) {
                if !value {
                    removeMusicApp()
                }
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
            // app 的右 component 存在的话，无论如何都要占用
            addToRightSlot(component: rightComponent)
        }
        if let fullComponent = app.fullComponent {
            addToFullSlot(component: fullComponent)
        }
    }

    func removeMusicApp() {
        guard let leftComponent = currentSnapShot.leftComponent else { return }
        guard let rightComponent = currentSnapShot.rightComponent else { return }
        guard let fullComponent = currentSnapShot.fullComponent else { return }
        if leftComponent.appType == .Music && rightComponent.appType == .Music && fullComponent.appType == .Music {
            currentSnapShot.leftComponent = nil
            currentSnapShot.rightComponent = nil
            currentSnapShot.fullComponent = nil
        }
    }

    func addTip(_ tip: NotchTip) {
        if let leftComponent = tip.leftComponent {
            // tip 的左 component 存在的话，无论如何都要占用
            addToLeftSlot(component: leftComponent)
        }

        if let rightComponent = tip.rightComponent {
            // tip 的右 component 存在的话，无论如何都要占用
            addToRightSlot(component: rightComponent)
        }
        if let fullComponent = tip.fullComponent {
            addToFullSlot(component: fullComponent)
        }
    }

    private func addToLeftSlot(component: NotchComponent) {
        currentSnapShot.leftComponent = component
    }

    private func addToRightSlot(component: NotchComponent) {
        currentSnapShot.rightComponent = component
    }

    private func addToFullSlot(component: NotchComponent) {
        currentSnapShot.fullComponent = component
    }

    // 导航的只可能是 app，tip存在时不允许滑动
    func navigate(isForward: Bool) {
        if isForward {
            guard let leftComponent = currentSnapShot.leftComponent else { return }
            guard let appType = leftComponent.appType else { return }
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
            guard let appType = rightComponent.appType else { return }
            guard let app = allApps[appType] else { return }
            guard let leftComponent = app.leftComponent else { return }
            // 显示该 app 的左 component
            if leftComponent != currentSnapShot.leftComponent {
                addToLeftSlot(component: leftComponent)
            }
        }
    }


    enum Direction {
        case None, Up, Down, Left, Right
    }

    func doubleTap() {
        if reachMore {
            shrinkOrExpand(direction: .Up)
            if displayMode == .Hide {
                reachMore = false
            }
        }
        else {
            shrinkOrExpand(direction: .Down)
            if displayMode == .More {
                reachMore = true
            }
        }
    }

    func shrinkOrExpand(deltaX: CGFloat, deltaY: CGFloat) {
        var direction: Direction = .None
        if displayMode == .Hide && deltaY > 3 {
            direction = .Down
        }
        else if displayMode == .Less && deltaY > 3 {
            direction = .Down
        }
        if displayMode == .Less && deltaY < -3 {
            direction = .Up
        }
        else if displayMode == .More && deltaY < -3 {
            direction = .Up
        }
        shrinkOrExpand(direction: direction)
    }

    func shrinkOrExpand(direction: Direction) {
        var newDisplayMode: NotchDisplayMode = displayMode
        if direction == .Up {
            if newDisplayMode == .More {
                newDisplayMode = .Less
            }
            else if newDisplayMode == .Less {
                newDisplayMode = .Hide
            }
        }
        else if direction == .Down {
            if newDisplayMode == .Hide {
                newDisplayMode = .Less
            }
            else if newDisplayMode == .Less {
                newDisplayMode = .More
            }
        }
        if displayMode != newDisplayMode {
            displayMode = newDisplayMode
            self.refreshSize()
        }
    }

    func refreshSize() {
        let hideDuration = showKeyPanel || showTips || showVolume ? 0.5 : 0.2
        let hideBounce = showKeyPanel || showTips || showVolume ? 0 : 0.1

        let lessDuration = showKeyPanel || showTips || showVolume ? 0.5 : 0.4
        let lessBounce = showKeyPanel || showTips || showVolume ? 0 : 0.2

        switch displayMode {
        case .Hide:
            withAnimation(.spring(duration: hideDuration, bounce: hideBounce)) {
                notchViewSize = CGSize(width: notchSize.width + (bHovering ? 5 : 0) + (showVolume ? 100 : 0), height: notchSize.height + (bHovering ? 5 : 0) + (showKeyPanel || showTips ? notchSize.height : 0))
            }
        case .Less:
            withAnimation(.spring(duration: lessDuration, bounce: lessBounce)) {
                notchViewSize = CGSize(width: notchSize.width + (bHovering ? 105 : 100), height: notchSize.height + (bHovering ? 5 : 0) + (showKeyPanel || showTips ? notchSize.height : 0))
            }
        case .More:
            withAnimation(.spring(duration: 0.5, bounce: 0.1)) {
                notchViewSize = CGSize(width: notchPanelRect.width, height: notchPanelRect.height)
            }
        }
    }
}
