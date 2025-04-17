//
//  Constant.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/17.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let notchWidth = Key<CGFloat>("notchWidth", default: 185)
    static let notchHeight = Key<CGFloat>("notchHeight", default: 32)
    static let notchHeightMode = Key<NotchHeightMode>("notchHeightMode", default: NotchHeightMode.matchRealNotchSize)
}
