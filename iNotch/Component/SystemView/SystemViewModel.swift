//
//  CPUViewModel.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/14.
//

import Foundation
import Combine
import System
import Defaults

@Observable
final class SystemViewModel: TickableViewModel {
    var cpuUsage: Double = 0.0
    var memoryUsage: Double = 0.0

    private var showHighCpuUsageWarning: Bool = false
    private var showNormalCpuUsageTips: Bool = false

    private var showHighMemoryUsageWarning: Bool = false
    private var showNormalMemoryUsageTips: Bool = false

    private var system = System()

    override init(tickInterval: TimeInterval = 10.0) {
        super.init(tickInterval: tickInterval)
    }

    private func highCpuUsage() -> Bool {
        return cpuUsage > 70
    }

    private func normalCpuUsage() -> Bool {
        return cpuUsage < 40
    }

    private func highMemoryUsage() -> Bool {
        return memoryUsage > 70
    }

    private func noamrlMemoryUsage() -> Bool {
        return memoryUsage < 40
    }

    public override func tick(_ params: [AnyHashable : Any]?) {
        if !Defaults[.featureSystem] {
            return
        }
        // Refresh cpuUsage value
        cpuUsage = retrieveCpuUsage()
        memoryUsage = retrieveMemoryUsage()

        if !showHighCpuUsageWarning && highCpuUsage() {
            Logger.log("now: \(Date.now)", category: .debug)
            postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "HighCpuWarning"])
            showHighCpuUsageWarning = true
            showNormalCpuUsageTips = false
        }

        if showHighCpuUsageWarning && !showNormalCpuUsageTips && normalCpuUsage() {
            Logger.log("now: \(Date.now)", category: .debug)
            postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "NormalCpu"])
            showNormalCpuUsageTips = true
            showHighCpuUsageWarning = false
        }

        if !showHighMemoryUsageWarning && highMemoryUsage() {
            Logger.log("now: \(Date.now)", category: .debug)
            postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "HighMemoryWarning"])
            showHighMemoryUsageWarning = true
            showNormalMemoryUsageTips = false
        }

        if showHighMemoryUsageWarning && !showNormalMemoryUsageTips && noamrlMemoryUsage() {
            Logger.log("now: \(Date.now)", category: .debug)
            postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "NormalMemory"])
            showNormalMemoryUsageTips = true
            showHighMemoryUsageWarning = false
        }
    }

    private func retrieveCpuUsage() -> Double {
        let usage = system.usageCPU()

        return usage.system + usage.user
    }

    private func retrieveMemoryUsage() -> Double {
        let usage = System.memoryUsage()

        return (usage.free / System.physicalMemory()) * 100
    }
}
