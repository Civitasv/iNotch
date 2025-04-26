//
//  SettingView.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/26.
//

import SwiftUI
import Setting

struct SettingView: View {
    /// Setting supports `@State`, `@AppStorage`, `@Published`, and more!
    @AppStorage("isOn") var isOn = true

    var body: some View {
        /// Start things off with `SettingStack`.
        SettingStack {
            /// This is the main settings page.
            SettingPage(title: "iNotch") {
                /// Use groups to group components together.
                SettingGroup(header: "Tips") {
                    /// Use any of the pre-made components...
                    SettingToggle(title: "电量提示", isOn: $isOn)

                    /// ...or define your own ones!
                    SettingCustomView {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 160)
                            .padding(20)
                    }

                    /// Nest `SettingPage` inside other `SettingPage`s!
                    SettingPage(title: "Advanced Settings") {
                        SettingText(title: "I show up on the next page!")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
