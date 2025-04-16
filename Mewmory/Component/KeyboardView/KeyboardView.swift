//
//  KeyboardView.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/15.
//

import SwiftUI

struct KeyboardView: View {
    @Environment(KeyboardViewModel.self) private var keyboardVm
    @Environment(PermissionsViewModel.self) private var permissionVm

    var body: some View {
        Text("Hello, \(String(permissionVm.isTrusted))!")
            .onAppear() {
                permissionVm.pollAccessibilityPrivileges {
                    self.keyboardVm.start()
                }
            }
        Text(keyboardVm.currentKey)
    }
}

#Preview {
    KeyboardView()
}
