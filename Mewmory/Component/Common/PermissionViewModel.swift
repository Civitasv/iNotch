//
//  PermissionGetter.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/16.
//

import Foundation
import SwiftUI

@Observable
final class PermissionsViewModel {
    var isTrusted: Bool = AXIsProcessTrusted()

    func pollAccessibilityPrivileges(onTrusted: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isTrusted = AXIsProcessTrusted()

            if !self.isTrusted {
                self.pollAccessibilityPrivileges(onTrusted: onTrusted)
            } else {
                onTrusted()
            }
        }
    }
    
    init() {
//        self.acquireAccessibilityPrivileges()
    }

    
}
