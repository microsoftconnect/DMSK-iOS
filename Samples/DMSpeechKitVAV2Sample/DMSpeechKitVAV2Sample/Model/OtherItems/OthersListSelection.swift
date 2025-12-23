//
//  OthersListSelection.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersListSelection: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_ITEM_NAME
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_POSITION_ORDINAL
    }
    
}
