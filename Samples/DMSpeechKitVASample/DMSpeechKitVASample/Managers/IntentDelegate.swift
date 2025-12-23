//
//  IntentDelegate.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol IntentDelegate: class {
    
    /**
     Intent - dmvaHelp was recognized, show the help screen
     */
    func showHelp()

    /**
     Intent - dmvaShowItem(setting) was recognized, show the settings screen
     */
    func showSettings()

    /**
     Show a particular kind of screen as a certain kind of intent was recognized. ScreenType & Intent mapping available in DialogResult.swift
     */
    func showScreen(type: ScreenType)

    /**
     Intent - dmvaDocumentSection was recognized, start the dictation
     */
    func startDictation()
    
}
