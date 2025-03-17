//
//  DataProviderFactory.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class DataProviderFactory {
    static func createDataProvider(type: ScreenType) -> CellDataProvider {
        return CellDataProviderImpl(type: type)
    }
}
