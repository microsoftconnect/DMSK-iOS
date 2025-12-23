//
//  OthersCall.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersCall: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_CALL_RECIPIENT
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_CALL_TITLE
    }
    
}
