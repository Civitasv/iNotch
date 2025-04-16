//
//  NotchLayout.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/16.
//

import SwiftUI

// Main Layout
struct NotchLayout: View {
    @State var hoverAnimation: Bool = false
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text("Charging")
                    .font(.subheadline)
            }

            Rectangle()
                .fill(.black)
                .frame(width: 100 + 5)

            HStack {
                BatteryView()
            }
            .frame(width: 76, alignment: .trailing)
        }
        .frame(height: 20 + (hoverAnimation ? 8 : 0), alignment: .center)
    }
}

#Preview {
    NotchLayout()
        .frame(width: 200, height: 30)
        .padding(20)
}
