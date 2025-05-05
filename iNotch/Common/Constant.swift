//
//  Constant.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/17.
//

import Foundation
import Defaults

extension Defaults.Keys {
#if DEBUG
    static let showGM = Key<Bool>("showGM", default: true)
#endif

    static let notchWidth = Key<CGFloat>("notchWidth", default: 185)
    static let notchHeight = Key<CGFloat>("notchHeight", default: 32)
    static let notchHeightMode = Key<NotchHeightMode>("notchHeightMode", default: NotchHeightMode.matchRealNotchSize)
    static let useMusicVisualizer = Key<Bool>("useMusicVisualizer", default: true)
    static let coloredSpectrogram = Key<Bool>("coloredSpectrogram", default: true)

    static let featureMusic = Key<Bool>("featureMusic", default: true)
    static let featureKeyboard = Key<Bool>("featureKeyboard", default: true)
    static let featureBattery = Key<Bool>("featureBattery", default: true)
    static let featureSystem = Key<Bool>("featureSystem", default: true)
    static let featureSound = Key<Bool>("featureSound", default: true)
}
