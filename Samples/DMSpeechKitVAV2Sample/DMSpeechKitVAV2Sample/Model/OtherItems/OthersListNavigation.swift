//
//  OthersListNavigation.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersListNavigation: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_NAVIGATION_DIRECTION
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
