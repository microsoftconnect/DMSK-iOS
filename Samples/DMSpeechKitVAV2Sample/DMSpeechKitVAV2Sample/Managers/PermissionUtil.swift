//
//  PermissionUtil.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation
import AVFoundation

final class PermissionUtil {
    
    private init() { }
    
    // Check Microphone Record permission
    private static func isMicrophonePermissionGranted() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted
    }
    
    // Request for setting Record permission
    private static func requestMicrophonePermission(completionHandler: @escaping () -> Void) {
        if AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.denied ||
            AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                } else {
                    Logger.log("Microphone permission denied")
                }
            }
        }
    }
    
    static func requestMicrophonePermissionAndExecute(operation: @escaping () -> Void) {
        if isMicrophonePermissionGranted() {
            operation()
        } else {
            requestMicrophonePermission(completionHandler: {
                operation()
            })
        }
    }
}

