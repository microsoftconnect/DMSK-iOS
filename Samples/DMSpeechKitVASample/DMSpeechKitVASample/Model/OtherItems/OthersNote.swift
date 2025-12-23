//
//  OthersNote.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersNote: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_OTHER_NOTES
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
