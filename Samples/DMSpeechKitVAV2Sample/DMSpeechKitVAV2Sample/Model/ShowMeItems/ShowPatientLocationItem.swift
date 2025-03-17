//
//  OthersShowPatientLocation.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientLocationItem: OtherItem {

    override func titleEntity() -> String {
        return ""   // Intentionally left blank
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_SHOW_PATIENT_TIMEFRAME
    }
    
}
