//
//  OthersScheduleSearch.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersScheduleSearch: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_SCHEDULE_SEARCH_TYPE
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
