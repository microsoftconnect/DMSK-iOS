//
//  OthersMedicationClassResults.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMedicationClassResultsItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_MEDICATION_RESULT_CLASS
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
