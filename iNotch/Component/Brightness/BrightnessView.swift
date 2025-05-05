//
//  VoiceAdjustingView.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/27.
//

import SwiftUI

struct BrightnessLeftView: View {
    @Environment(BrightnessViewModel.self) var brightnessVm
    @Environment(NotchViewModel.self) var notchVm

    private var notchSize = getClosedNotchSize()

    var body: some View {
        Image(systemName: brightnessVm.imageName)
            .contentTransition(.symbolEffect(.replace))
            .frame(width: min(15, notchSize.height - 12), height: min(15, notchSize.height - 12), alignment: .center)
            .padding(5)
    }
}

struct BrightnessRightView: View {
    @Environment(BrightnessViewModel.self) var brightnessVm
    @Environment(NotchViewModel.self) var notchVm

    @State private var sliderValue: Double = 0
    @State private var dragging: Bool = false

    private var notchSize = getClosedNotchSize()

    var body: some View {
        CustomSlider(
            value: $sliderValue,
            dragging: $dragging,
            range: 0 ... 1,
            color: .white
        ) { value in
            brightnessVm.setBrightness(brightness: value)
        }
        .onChange(of: brightnessVm.volume) { _, _ in
            guard !dragging else { return }
            sliderValue = Double(brightnessVm.volume)
        }
        .frame(width: 100, height: 12, alignment: .center)
    }
}

#Preview {
    BrightnessLeftView()
        .environment(BrightnessViewModel())
        .environment(NotchViewModel())
        .frame(width: 200, height: 200)
}
