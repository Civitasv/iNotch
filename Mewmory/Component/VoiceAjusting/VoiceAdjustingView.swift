//
//  VoiceAdjustingView.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/27.
//

import SwiftUI

struct VoiceLessLeftView: View {
    @Environment(VoiceAjustingViewModel.self) var voiceVm
    @Environment(NotchViewModel.self) var notchVm

    @State var text: String = "No Change"
    private var notchSize = getClosedNotchSize()

    @State private var sliderValue: Double = 0
    @State private var dragging: Bool = false
    
    var body: some View {
        Text("Hello \(voiceVm.volume)")
        Text("Hello \(String(text))")
            .onChange(of: voiceVm.isChanged) { _, _ in
                if voiceVm.isChanged {
                    text = "Changing"
                } else {
                    text = "No Change"
                }
            }
        CustomSlider(
            value: $sliderValue,
            dragging: $dragging,
            range: 0 ... 1,
            color: .white
        ) { value in
            voiceVm.setVolume(volume: value)
        }
        .onChange(of: voiceVm.volume) { _, _ in
            guard !dragging else { return }
            sliderValue = Double(voiceVm.volume)
        }
        .frame(height: 10, alignment: .center)
    }
}

#Preview {
    VoiceLessLeftView()
        .environment(VoiceAjustingViewModel())
        .environment(NotchViewModel())
        .frame(width: 200, height: 200)
}
