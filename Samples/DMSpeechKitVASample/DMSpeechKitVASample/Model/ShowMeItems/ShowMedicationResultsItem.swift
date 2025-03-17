//
//  OthersMedicationResults.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationResultsItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_MEDICATION_RESULT
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
