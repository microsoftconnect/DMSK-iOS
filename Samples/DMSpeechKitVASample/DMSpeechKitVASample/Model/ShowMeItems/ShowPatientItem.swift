//
//  OthersShowPatient.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowPatientItem: OtherItem {

    override func titleConcept() -> String {
        return ""   // Intentionally left blank
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_SHOW_PATIENT_TIMEFRAME
    }
    
}
