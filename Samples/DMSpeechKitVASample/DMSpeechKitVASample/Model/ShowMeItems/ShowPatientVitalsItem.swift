//
//  OthersPatientVitals.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientVitalsItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_PATIENT_VITALS
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
