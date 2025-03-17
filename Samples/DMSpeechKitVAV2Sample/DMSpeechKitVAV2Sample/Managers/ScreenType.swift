//
//  ScreenType.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ScreenType {
    
    public let title: String
    
    private init(title: String) {
        self.title = title
    }
    
    public static let HOME = ScreenType(title: Constants.SCREEN_TITLE_HOME)
    public static let MEDICATION = ScreenType(title: Constants.SCREEN_TITLE_MEDICATION)
    public static let REMINDER = ScreenType(title: Constants.SCREEN_TITLE_REMINDER)
    public static let MESSAGES = ScreenType(title: Constants.SCREEN_TITLE_MESSAGES)
    public static let OTHER = ScreenType(title: Constants.SCREEN_TITLE_OTHER)
    public static let SHOWME = ScreenType(title: Constants.SCREEN_TITLE_SHOWME)
    public static let NOTES = ScreenType(title: Constants.SCREEN_TITLE_NOTES)
    public static let HELP = ScreenType(title: Constants.SCREEN_TITLE_HELP)
    public static let SETTING = ScreenType(title: Constants.SCREEN_TITLE_SETTING)
    public static let SCREENS = [HOME, MEDICATION, MESSAGES, REMINDER, OTHER, SHOWME, NOTES, HELP, SETTING]
}

extension ScreenType: Equatable {
    static func == (lhs: ScreenType, rhs: ScreenType) -> Bool {
        return lhs.title == rhs.title
    }
}

