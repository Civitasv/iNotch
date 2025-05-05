//
//  VoiceAjustingViewModel.swift
//  iNotch
//
//  Created by Civitasv on 2025/4/27.
//

import Foundation
import Defaults

@Observable
final class SoundAdjustingViewModel : TickableViewModel {
    var volume: Float = Sound.output.volume
    var isChanged: Bool = false

    var imageName: String = ""

    override init(tickInterval: TimeInterval = 0.1) {
        super.init(tickInterval: tickInterval)
        refreshImage(prevVolume: volume, currentVolume: volume)
    }

    public override func tick(_ params: [AnyHashable : Any]?) {
        if !Defaults[.featureSound] {
            return
        }
        refreshSoundInfo()
    }

    private func refreshSoundInfo() {
        let currentVolume = Sound.output.volume
        if self.volume != currentVolume {
//            refreshImage(prevVolume: self.volume, currentVolume: currentVolume)

            self.volume = currentVolume
            self.isChanged = true

            postEvent(name: "SoundAdjustingViewModel.VolumeChange", params: ["Volume": currentVolume])
        }
        else {
            self.isChanged = false

            refreshImage(prevVolume: self.volume, currentVolume: currentVolume)
        }
    }

    public func setVolume(volume: Double) {
        let muteThreshold: Float = 0.0
        Sound.output.setVolume(Float(volume), autoMuteUnmute: true, muteThreshold: muteThreshold)
    }

    private func refreshImage(prevVolume: Float, currentVolume: Float) {
        if prevVolume == currentVolume {
            if currentVolume <= 0 {
                imageName = "speaker.slash"
            } else if currentVolume <= 0.33 {
                imageName = "speaker.wave.1"
            } else if currentVolume <= 0.66 {
                imageName = "speaker.wave.2"
            } else if currentVolume <= 1.0 {
                imageName = "speaker.wave.3"
            }
        } else if prevVolume < currentVolume {
            imageName = "speaker.plus"
        } else {
            imageName = "speaker.minus"
        }
    }
}
