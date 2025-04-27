//
//  VoiceAjustingViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/27.
//

import Foundation

@Observable
final class VoiceAjustingViewModel : TickableViewModel {
    var volume: Float = 0.0
    var isChanged: Bool = false

    override init(tickInterval: TimeInterval = 0.2) {
        super.init(tickInterval: tickInterval)
    }
    
    public override func tick(_ params: [AnyHashable : Any]?) {
        refreshSoundInfo()
    }
    
    private func refreshSoundInfo() {
        let currentVolume = Sound.output.volume
        if self.volume != currentVolume {
            self.volume = currentVolume
            self.isChanged = true
        }
        else {
            self.isChanged = false
        }
    }
    
    public func setVolume(volume: Double) {
        let muteThreshold: Float = 0.0
        Sound.output.setVolume(Float(volume), autoMuteUnmute: true, muteThreshold: muteThreshold)
    }
}
