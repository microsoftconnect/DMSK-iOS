//
//  Setting.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class Setting {
    public let key: String
    public var value: String
    public let editable: Bool
    
    /**
     - Parameter key: e.g. Model ID
     - Parameter value: e.g. PhysicianVirtualAssistant_101
     - Parameter editable: Some of the fields shown in the Settings screen are read-only
     */
    private init(key: String, value: String, editable: Bool) {
        self.key = key
        self.value = value
        self.editable = editable
    }
    
    public static let APP_NAME = Setting(key: Constants.SETTINGS_APP_NAME, value: Constants.DEFAULT_APP_NAME, editable: false)
    public static let MODEL_ID = Setting(key: Constants.SETTINGS_MODEL_ID, value: Constants.DEFAULT_MODEL_ID, editable: false)
    public static let VERSION = Setting(key: Constants.SETTINGS_VERSION, value: Constants.DEFAULT_APP_VERSION, editable: false)
    public static let SETTINGS = [APP_NAME, MODEL_ID, VERSION]
    
}
