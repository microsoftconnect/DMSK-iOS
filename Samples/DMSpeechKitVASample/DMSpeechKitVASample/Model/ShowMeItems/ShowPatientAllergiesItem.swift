//
//  OthersPatientAllergies.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientAllergiesItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_PATIENT_ALLERGIES
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_PATIENT_ALLERGIES_MEDS
    }
    
}
