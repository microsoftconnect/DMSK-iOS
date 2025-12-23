//
//  OthersPatientAllergies.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientAllergiesItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_PATIENT_ALLERGIES
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_PATIENT_ALLERGIES_MEDS
    }
    
}
