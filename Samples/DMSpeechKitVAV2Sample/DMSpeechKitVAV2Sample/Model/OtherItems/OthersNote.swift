//
//  OthersNote.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersNote: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_OTHER_NOTES
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
