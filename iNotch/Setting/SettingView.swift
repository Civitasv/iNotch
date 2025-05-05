//
//  SettingView.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/26.
//

import SwiftUI
import Setting
import Defaults

struct SettingView: View {
    /// Setting supports `@State`, `@AppStorage`, `@Published`, and more!
    @Default(.featureMusic) var featureMusic
    @Default(.featureSystem) var featureCpu
    @Default(.featureSound) var featureSound
    @Default(.featureBattery) var featureBattery
    @Default(.featureKeyboard) var featureKeyboard

    @AppStorage("region") var region = 0

    var body: some View {
        SettingStack {
            SettingPage(title: "iNotch") {
                SettingGroup(header: "Region") {
                    SettingPicker(
                       title: "Language",
                       choices: ["简体中文", "English"],
                       selectedIndex: $region
                   )
                }

                SettingGroup(header: "Tips") {
                    SettingToggle(title: "Battery", isOn: $featureBattery)
                    SettingToggle(title: "System Usage", isOn: $featureCpu)
                    SettingToggle(title: "Show Current Pressed Key", isOn: $featureKeyboard)
                    SettingToggle(title: "Sound Volume Change", isOn: $featureSound)
                }

                SettingGroup(header: "Activity") {
                    SettingToggle(title: "Apple Music", isOn: $featureMusic)
                }

                SettingGroup(header: "Coming soon") {
                    SettingText(title: "Feature Request")
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
