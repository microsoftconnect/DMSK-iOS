//
//  OthersCall.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersCall: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_CALL_RECIPIENT
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_CALL_TITLE
    }
    
}
