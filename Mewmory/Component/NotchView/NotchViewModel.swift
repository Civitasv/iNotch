//
//  NotchViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/17.
//

import Foundation
import Defaults
import SwiftUI

@Observable
final class NotchViewModel {
    var notchViewSize: CGSize // the view size of notch bar
    var bHovering: Bool

    init() {
        notchViewSize = getClosedNotchSize()
        bHovering = false
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
}
