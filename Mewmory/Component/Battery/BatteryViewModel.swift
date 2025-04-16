//
//  BatteryViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/16.
//

import Foundation

@Observable
final class BatteryViewModel {
    var percentage: Int = 0
    var bCharging: Bool = false
    
    init(percentage: Int, bCharging: Bool) {
        self.percentage = percentage
        self.bCharging = bCharging
    }

    public func isLowPowerMode() -> Bool {
        return percentage <= 40
    }
    
    public func isDangerousPowerMode() -> Bool {
        return percentage <= 20
    }
}
