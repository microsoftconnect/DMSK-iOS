//
//  OthersMemberLookup.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersMemberLookup: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_MEMBER_DYNAMIC
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_MEMBER_ID
    }
    
}
