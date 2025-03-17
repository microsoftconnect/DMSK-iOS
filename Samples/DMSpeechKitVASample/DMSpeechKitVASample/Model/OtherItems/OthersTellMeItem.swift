//
//  OthersTellMeItem.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersTellMeItem: OtherItem {
    
    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_TELL_ITEM
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_TELL_ITEM_TIME
    }
    
}
