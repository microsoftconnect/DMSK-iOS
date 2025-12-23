//
//  OthersTellMeItem.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersTellMeItem: OtherItem {
    
    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_TELL_ITEM
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_TELL_ITEM_TIME
    }
    
}
