//
//  KeyboardView.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/15.
//

import SwiftUI

struct KeyboardView: View {
    @Environment(KeyboardViewModel.self) private var keyboardVm
    @Environment(NotchViewModel.self) private var notchVm
    
    private var notchSize = getClosedNotchSize()
    var body: some View {
        Key(width: 100, height: notchSize.height, key: keyboardVm.keyString, modifier: keyboardVm.modifierString)
            .frame(width: 80, height: notchSize.height)
    }
}

struct Key: View {
    var width: CGFloat
    var height: CGFloat
    var key: String
    var modifier: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if !modifier.isEmpty {
                Text(modifier)
                    .foregroundStyle(.white)
                Text(" + ")
                    .foregroundStyle(.red)
            }
            
            Text(key)
                .foregroundStyle(.white)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    KeyboardView()
        .environment(KeyboardViewModel())
        .environment(NotchViewModel())
        .frame(width: 200, height: 200)
}
