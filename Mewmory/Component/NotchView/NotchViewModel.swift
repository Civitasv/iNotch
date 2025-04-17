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
    var notchSize: CGSize

    init() {
        notchSize = getClosedNotchSize()
    }
}
