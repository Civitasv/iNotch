//
//  BrightnessViewModel.swift
//  iNotch
//
//  Created by 胡森 on 2025/5/3.
//

import Foundation

@Observable
final class BrightnessViewModel : TickableViewModel {
    var volume: Float = Sound.output.volume
    var isChanged: Bool = false
    
    var imageName: String = ""
    
    override init(tickInterval: TimeInterval = 0.1) {
        super.init(tickInterval: tickInterval)
        refreshImage(prevBrightness: volume, currentBrightness: volume)
    }
    
    public override func tick(_ params: [AnyHashable : Any]?) {
        refreshBrightnessInfo()
    }
    
    private func refreshBrightnessInfo() {
        let currentVolume = Sound.output.volume
        if self.volume != currentVolume {
//            refreshImage(prevVolume: self.volume, currentVolume: currentVolume)
            
            self.volume = currentVolume
            self.isChanged = true
            
            postEvent(name: "SoundAdjustingViewModel.BrightnessChange", params: ["Volume": currentVolume])
        }
        else {
            self.isChanged = false
            
            refreshImage(prevBrightness: self.volume, currentBrightness: currentVolume)
        }
    }
    
    public func setBrightness(brightness: Double) {

    }
    
    private func refreshImage(prevBrightness: Float, currentBrightness: Float) {
//        if prevVolume == currentVolume {
//            if currentVolume <= 0 {
//                imageName = "speaker.slash"
//            } else if currentVolume <= 0.33 {
//                imageName = "speaker.wave.1"
//            } else if currentVolume <= 0.66 {
//                imageName = "speaker.wave.2"
//            } else if currentVolume <= 1.0 {
//                imageName = "speaker.wave.3"
//            }
//        } else if prevVolume < currentVolume {
//            imageName = "speaker.plus"
//        } else {
//            imageName = "speaker.minus"
//        }
    }
}
