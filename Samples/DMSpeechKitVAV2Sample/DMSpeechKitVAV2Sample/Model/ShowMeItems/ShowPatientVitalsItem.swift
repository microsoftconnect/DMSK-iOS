//
//  OthersPatientVitals.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientVitalsItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_PATIENT_VITALS
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
