//
//  OthersListSelection.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersListSelection: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_ITEM_NAME
    }
    
    override func descriptionConcept() -> String {
        return ConceptsUtil.CONCEPT_POSITION_ORDINAL
    }
    
}
