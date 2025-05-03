//
//  QQMusicApplication.swift
//  iNotch
//
//  Created by 胡森 on 2025/4/26.
//

import Foundation
import Carbon

class QQMusicApplication {
    var isRunning: Bool = false
    
    var nextTrackScript: NSAppleScript?
    var prevTrackScript: NSAppleScript?
    var playpauseScript: NSAppleScript?
    
    func nextTrack() async {
        if self.nextTrackScript == nil {
            self.nextTrackScript = {
               let script = NSAppleScript(source: """
                   tell application "System Events" to tell process "QQMusic"
                      click menu item 3 of menu 1 of menu bar item 4 of menu bar 1
                   end tell
                   """
               )!
               let success = script.compileAndReturnError(nil)
               assert(success)
               return script
           }()
        }
        guard let nextTrackScript = self.nextTrackScript else { return }
        var possibleError: NSDictionary? = nil
        nextTrackScript.executeAndReturnError(&possibleError)
        
        if let error = possibleError {
            Logger.log("ERROR: \(error)", category: .debug)
        }
    }
    
    func prevTrack() async {
        if self.prevTrackScript == nil {
            self.prevTrackScript = {
               let script = NSAppleScript(source: """
                   tell application "System Events" to tell process "QQMusic"
                      click menu item 2 of menu 1 of menu bar item 4 of menu bar 1
                   end tell
                   """
               )!
               let success = script.compileAndReturnError(nil)
               assert(success)
               return script
           }()
        }
        guard let prevTrackScript = self.prevTrackScript else { return }
        var possibleError: NSDictionary? = nil
        prevTrackScript.executeAndReturnError(&possibleError)
        
        if let error = possibleError {
            Logger.log("ERROR: \(error)", category: .debug)
        }
    }
    
    func playPause() async {
        if self.playpauseScript == nil {
            self.playpauseScript = {
               let script = NSAppleScript(source: """
                   tell application "System Events" to tell process "QQMusic"
                      click menu item 1 of menu 1 of menu bar item 4 of menu bar 1
                   end tell
                   """
               )!
               let success = script.compileAndReturnError(nil)
               assert(success)
               return script
           }()
        }
        guard let playpauseScript = self.playpauseScript else { return }
        var possibleError: NSDictionary? = nil
        playpauseScript.executeAndReturnError(&possibleError)
        
        if let error = possibleError {
            Logger.log("ERROR: \(error)", category: .debug)
        }
    }
}
