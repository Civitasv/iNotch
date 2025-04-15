//
//  CPUViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/14.
//

import Foundation

@Observable
final class CPUViewModel {
    var cpuUsage: Double? = 0.0

    public func tick() {
        // Refresh cpuUsage value
        cpuUsage = CPUProvider.getCPUUsage()
    }
}
