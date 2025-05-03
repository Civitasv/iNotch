//
//  BatteryViewModel.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/16.
//

import Foundation
import IOKit.ps
import SwiftUI
import Defaults

@Observable
final class BatteryViewModel {
    var percentage: Int = 0
    var bCharging: Bool = false
    var lowPowerTipsShown: Bool = false
    private var powerSourceChangedCallback: IOPowerSourceCallbackType?
    private var runLoopSource: Unmanaged<CFRunLoopSource>?

    init() {
        if !Defaults[.featureBattery] {
            return
        }
        self.updateBatteryStatus()
        self.startMonitoring()
    }
    
    deinit {
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource.takeUnretainedValue(), .defaultMode)
            runLoopSource.release()
        }
    }

    public func isLowPowerMode() -> Bool {
        return percentage <= 40
    }
    
    public func isDangerousPowerMode() -> Bool {
        return percentage <= 20
    }
    
    private func updateBatteryStatus() {
        if let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
           let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] {
            for source in sources {
                if let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: AnyObject],
                   let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int,
                   let maxCapacity = info[kIOPSMaxCapacityKey] as? Int,
                   let bCharging = info["Is Charging"] as? Bool,
                   let powerSource = info[kIOPSPowerSourceStateKey] as? String {
                    withAnimation {
                        self.percentage = Int((currentCapacity * 100) / maxCapacity)
                    }

                    let isACPower = powerSource == "AC Power"

                    Logger.log("isACPower: \(isACPower)", category: .ui)
                    withAnimation {
                        self.bCharging = bCharging || isACPower
                    }
                    
                    if isLowPowerMode() && !lowPowerTipsShown {
                        postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "LowBattery"])
                        lowPowerTipsShown = true
                    }
                }
            }
        }
    }
    
    private func startMonitoring() {
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        powerSourceChangedCallback = { context in
            if let context = context {
                let mySelf = Unmanaged<BatteryViewModel>.fromOpaque(context).takeUnretainedValue()
                DispatchQueue.main.async {
                    mySelf.updateBatteryStatus()
                }
            }
        }

        if let runLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceChangedCallback!, context)?.takeRetainedValue() {
            self.runLoopSource = Unmanaged<CFRunLoopSource>.passRetained(runLoopSource)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
        }
    }
}
