//
//  CPUViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/14.
//

import Foundation
import Combine

@Observable
final class CPUViewModel: BasicViewModel {
    var cpuUsage: Double = 0.0
    
    override init(tickInterval: TimeInterval = 10.0) {
        super.init(tickInterval: tickInterval)
    }
    
    private func highCpuUsage() -> Bool {
        return cpuUsage > 20
    }
    
    public override func tick(_ params: [AnyHashable : Any]?) {
        // Refresh cpuUsage value
        cpuUsage = CPUProvider.getCPUUsage()
        
        if highCpuUsage() {
            Logger.log("now: \(Date.now)", category: .debug)
            postEvent(name: "NotchViewModel.ShowTips", params: ["Tips": "⚠️ CPU占用过高"])
        }
    }
}
