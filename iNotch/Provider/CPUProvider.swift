//
//  CPUMonitor.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/13.
//

import Foundation
import Combine
import System

final class CPUProvider {
    fileprivate static var system = System()

    public static func getCPUUsage() -> Double {
        var usage = system.usageCPU()

        return usage.system + usage.user
    }
}
