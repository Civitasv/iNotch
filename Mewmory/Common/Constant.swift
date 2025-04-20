//
//  Constant.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/17.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let showGM = Key<Bool>("showGM", default: true)
    
    static let notchWidth = Key<CGFloat>("notchWidth", default: 185)
    static let notchHeight = Key<CGFloat>("notchHeight", default: 32)
    static let notchHeightMode = Key<NotchHeightMode>("notchHeightMode", default: NotchHeightMode.matchRealNotchSize)
    static let useMusicVisualizer = Key<Bool>("useMusicVisualizer", default: true)
    static let coloredSpectrogram = Key<Bool>("coloredSpectrogram", default: true)
}

// 灵动岛显示模式，分为隐藏、较少显示、更多显示
enum DisplayMode: Int {
    case Hide = 0
    case Less = 1
    case More = 2
}
