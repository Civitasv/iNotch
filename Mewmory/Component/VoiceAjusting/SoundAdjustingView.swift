//
//  VoiceAdjustingView.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/27.
//

import SwiftUI

struct SoundLessLeftView: View {
    @Environment(SoundAdjustingViewModel.self) var soundVm
    @Environment(NotchViewModel.self) var notchVm

    private var notchSize = getClosedNotchSize()

    var body: some View {
        Image(systemName: soundVm.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: min(15, notchSize.height - 12), height: min(15, notchSize.height - 12), alignment: .center)
            .padding(5)
    }
}

struct SoundLessRightView: View {
    @Environment(SoundAdjustingViewModel.self) var soundVm
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
            soundVm.setVolume(volume: value)
        }
        .onChange(of: soundVm.volume) { _, _ in
            guard !dragging else { return }
            sliderValue = Double(soundVm.volume)
        }
        .frame(width: 100, height: 12, alignment: .center)
    }
}

#Preview {
    SoundLessLeftView()
        .environment(SoundAdjustingViewModel())
        .environment(NotchViewModel())
        .frame(width: 200, height: 200)
}
