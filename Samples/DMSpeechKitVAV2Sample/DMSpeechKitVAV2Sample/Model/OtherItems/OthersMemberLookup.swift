//
//  OthersMemberLookup.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersMemberLookup: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_MEMBER_DYNAMIC
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_MEMBER_ID
    }
    
}
