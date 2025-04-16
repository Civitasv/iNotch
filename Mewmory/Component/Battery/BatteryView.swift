//
//  BoringBattery.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/16.
//

import SwiftUI

struct BatteryIcon: View {
    var batteryVm: BatteryViewModel

    var batteryWidth: CGFloat = 26
    var icon: String {
        return "battery.0"
    }
    
    var batteryColor: Color {
        if batteryVm.isLowPowerMode() {
            return .yellow
        } else if batteryVm.isDangerousPowerMode() {
            return .red
        } else if batteryVm.bCharging {
            return .green
        } else {
            return .white
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: icon)
                .resizable()
                .fontWeight(.thin)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.5))
                .frame(
                    width: batteryWidth + 1
                )
            
            RoundedRectangle(cornerRadius: 2.5)
                .fill(batteryColor)
                .frame(width: CGFloat(((CGFloat(CFloat(batteryVm.percentage)) / 100) * (batteryWidth - 6))),
                       height: (batteryWidth - 2.75) - 18
                )
                .padding(.leading, 2)
            if batteryVm.bCharging {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                    .padding(.leading, 7)
                    .offset(y: -1)
            }
        }
    }
}

struct BatteryView: View {
    @State var batteryVm = BatteryViewModel(percentage: 20, bCharging: true)
    
    var body: some View {
        HStack {
            Text("\(batteryVm.percentage)%")
                .font(.callout)
                .foregroundStyle(.white)
            BatteryIcon(batteryVm: batteryVm, batteryWidth: 30)
        }
    }
}

#Preview {
    BatteryView().frame(width: 200, height: 200)
}

