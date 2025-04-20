//
//  MusicViewModel.swift
//  Mewmory
//
//  Created by 胡森 on 2025/4/19.
//

import Foundation
import SwiftUI
import Combine
import ScriptingBridge

enum AppEvent {
    // AppleMusic Event: https://medium.com/macoclock/finding-distributed-notifications-on-macos-catalina-b2a292aac5a1
    static let AppleMusic = "com.apple.Music.playerInfo"
}

struct MusicTrack: Equatable {
    var title: String = ""
    var artist: String = ""
    var album: String = ""
    var artwork: NSImage? = nil
    var duration: TimeInterval = 0
    var durationString: String = "--:--"
    var progress: TimeInterval = 0
    var progressString: String = "--:--"
    var isPlaying: Bool = false
    var progressPercent: Double = 0.0
    var avgColor: NSColor = .white
}

// Attention: 通过程序直接获取 nowPlaying 的值是 private api，无法上 apple store: https://stackoverflow.com/a/61494862

@Observable
final class MusicViewModel {
    // Observed Variables
    var currentTrack: MusicTrack = MusicTrack()
    var automationPermissionEnabled = false

    // Private
    private var prevTitle: String = ""
    private var prevIsPlaying: Bool = false
    private let appleMusic = application(name: "Music") as! AppleMusicApplication
    private let timer = Timer.publish(every: 0.13, on: .main, in: .common).autoconnect()
    private var cancellables = Set<AnyCancellable>()

    init() {
        Logger.log("Init \(appleMusic.mute!) \(appleMusic.name!)", category: .debug)

        Task {
            await self.registerControlAppleMusic()
        }
        // refresh it every 1s
        timer.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.refreshMusicInfo()
            }
            .store(in: &cancellables)
    }

    deinit {
    }

    private func refreshMusicInfo() {
        if let currentPlaying = appleMusic.currentTrack,
           let currentMusicArtworks: SBElementArray = currentPlaying.artworks?(),
           let currentMusicArtwork = currentMusicArtworks[0] as AnyObject? {
            currentTrack.title = currentPlaying.name ?? ""
            currentTrack.album = currentPlaying.album ?? ""
            currentTrack.artwork = currentMusicArtwork.data
            currentTrack.artist = currentPlaying.artist ?? ""
            currentTrack.duration = currentPlaying.duration ?? 0
            currentTrack.progress = appleMusic.playerPosition ?? 0
            currentTrack.isPlaying = appleMusic.playerState == .playing
            currentTrack.progressString = Duration.milliseconds(currentTrack.progress * 1000).formatted(.time(pattern: .minuteSecond))
            currentTrack.durationString = Duration.milliseconds(currentTrack.duration * 1000).formatted(.time(pattern: .minuteSecond))
            currentTrack.progressPercent = Double(currentTrack.progress) / Double(currentTrack.duration)
            if currentTrack.title != prevTitle {
                updateAvgColor()
            }
            prevTitle = currentTrack.title
//            Logger.log("Progress: \(currentTrack.progress) \(currentTrack.progressString)", category: .debug)
        }
        if currentTrack.isPlaying != prevIsPlaying {
            postEvent(name: "MusicViewModel.CurrentTrack.IsPlaying", params: ["IsPlaying": currentTrack.isPlaying])
            prevIsPlaying = currentTrack.isPlaying
        }
    }

    // @Deprecated see https://www.reddit.com/r/MacOSBeta/comments/1j5vmbj/macos_beta_154_issues_with_track_changes_in_apple/
    private func registerEvents() {
        DistributedNotificationCenter.default().publisher(for: Notification.Name(AppEvent.AppleMusic))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                guard let self else { return }
                print(state)
            })
    }

    // 注意：需要在 target 的 info 设置 NSAppleEventsUsageDescription，根目录里的 info.plist 设置不会生效
    // https://stackoverflow.com/a/52960825
    private func registerControlAppleMusic() async {
        Logger.log("Start", category: .debug)
        Task.detached {
            if let bundleIdentifier = getBundelIdentifier(name: "Music") {
                Logger.log("bundleIdentifier: \(bundleIdentifier)", category: .debug)
                let targetAEDescriptor = NSAppleEventDescriptor(bundleIdentifier: bundleIdentifier)
                let status = AEDeterminePermissionToAutomateTarget(targetAEDescriptor.aeDesc, typeWildCard, typeWildCard, true)

                Logger.log("Status: \(status)", category: .debug)
                Task { @MainActor in
                    switch status {
                    case noErr:
                        self.automationPermissionEnabled = true
                        Logger.log("Automation authorisation was granted", category: .debug)
                    case OSStatus(errAEEventNotPermitted):
                        self.automationPermissionEnabled = false
                        self.showAlert(message: "Missing required automation permissions", onSettingsTap: self.openAutomationSettings)
                        Logger.log("Automation authorisation was denied", category: .debug)
                    case OSStatus(procNotFound), _:
                        Logger.log("AppleMusic is not running", category: .debug)
                    }
                }
            }
        }
    }

    private func showAlert(message: String, onSettingsTap: () -> Void) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = message
        alert.addButton(withTitle: "Go to Settings")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            onSettingsTap()
        default:
            break
        }
    }

    func openAutomationSettings() {
        NSWorkspace.shared.open("x-apple.systempreferences:com.apple.preference.security?Privacy_Automation".asURL!)
    }
    
    // --------------------------- coverImage color --------------------------------
    func updateAvgColor() {
        if let currentTrackImage = currentTrack.artwork {
            currentTrackImage.averageColor { [weak self] color in
                guard let self else { return }
                DispatchQueue.main.async {
                    withAnimation(.smooth) {
                        self.currentTrack.avgColor = color ?? .white
                        Logger.log("Update Avg Color Success", category: .ui)
                    }
                }
            }
        }
    }

    // --------------------------- Apple Music -----------------------------
    func openAppleMusic() {
        if let bundleIdentifier = getBundelIdentifier(name: "Music") {
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else { return }

            let path = "/bin"
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.arguments = [path]
            NSWorkspace.shared.openApplication(at: url,
                                               configuration: configuration,
                                               completionHandler: nil)
        }
    }

    func playPause() {
        appleMusic.playpause?()
    }
    
    func prevTrack() {
        appleMusic.previousTrack?()
    }

    func nextTrack() {
        appleMusic.nextTrack?()
    }
    
    func seek(pos: Double) {
        appleMusic.setPlayerPosition?(pos)
    }
}
