//
//  OthersMedicationTime.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationTimeItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_MEDICATION_TIME
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
