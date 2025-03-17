//
//  OthersMedicationClassTime.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationClassTimeItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_MEDICATION_TIME_CLASS
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
