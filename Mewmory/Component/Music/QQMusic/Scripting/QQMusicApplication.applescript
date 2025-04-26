script QQMusicApplication
    property parent : class "NSObject"
    
    to isRunning() -- () -> NSNumber(Bool)
        
        return running of application id "com.apple.Music"
    end isRunning
    
end script
