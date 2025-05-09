//
//  TickProtocol.swift
//  TickProtocol
//
//  Created by Civitasv on 2025/4/26.
//

import Foundation

protocol TickProtocol {
    func tick(_ params: [AnyHashable : Any]?)
}

class TickableViewModel: TickProtocol {
    private var lastTick: Date = Date.now

    init(tickInterval: TimeInterval) {
        Logger.log("init", category: .debug)
        registerEvent(name: "iNotchApp.Tick") { [weak self] userInfo in
            guard let self else { return }

            guard Date.now.timeIntervalSince(lastTick) > tickInterval else {
                return
            }
            tick(userInfo)
            lastTick = Date.now
        }
    }

    func tick(_ params: [AnyHashable : Any]?) {

    }
}
