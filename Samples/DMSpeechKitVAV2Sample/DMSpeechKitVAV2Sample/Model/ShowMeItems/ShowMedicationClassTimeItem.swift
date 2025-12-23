//
//  OthersMedicationClassTime.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationClassTimeItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_MEDICATION_TIME_CLASS
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
