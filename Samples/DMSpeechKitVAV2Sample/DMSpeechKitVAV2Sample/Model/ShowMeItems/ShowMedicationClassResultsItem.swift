//
//  OthersMedicationClassResults.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationClassResultsItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_MEDICATION_RESULT_CLASS
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
