//
//  MedicationDataProvider.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol CellDataProvider {
    func providerType() -> ScreenType
    func numberOfRows() -> Int
    func data(forRow row: Int) -> Model?
    func add(item: Model)
    func updateLast(item: Model)
    func removeLast()
}

class CellDataProviderImpl: CellDataProvider {
    var dataItems: [Model] = []
    let type: ScreenType
    init(type: ScreenType) {
        self.type = type
    }
    
    internal func providerType() -> ScreenType {
        return type
    }
    
    internal func numberOfRows() -> Int {
        return dataItems.count
    }
    
    internal func data(forRow row: Int) -> Model? {
        return dataItems[row]
    }
    
    internal func add(item: Model) {
        dataItems.append(item)
    }
    
    internal func updateLast(item: Model) {
        dataItems.removeLast()
        dataItems.append(item)
    }
    
    internal func removeLast() {
        dataItems.removeLast()
    }
}
