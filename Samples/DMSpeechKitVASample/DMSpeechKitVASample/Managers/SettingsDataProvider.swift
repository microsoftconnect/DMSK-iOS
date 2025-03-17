//
//  SettingsDataProvider.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol SettingsDataProvider {
    /**
     Provides the Setting item at an index
     */
    func getRow(at: Int) -> Setting
    
    /**
     Provides the number of setting items to be shown
     */
    func getRowCount() -> Int
}

class SettingsDataProviderImpl: SettingsDataProvider {
    static let shared = SettingsDataProviderImpl()
    
    private init() { }

    internal func getRowCount() -> Int {
        return Setting.SETTINGS.count
    }
    
    internal func getRow(at: Int) -> Setting {
        return Setting.SETTINGS[at]
    }
}
