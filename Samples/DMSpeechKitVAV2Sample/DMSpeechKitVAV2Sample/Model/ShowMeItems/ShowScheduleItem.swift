//
//  OthersShowSchedule.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowScheduleItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_SHOW_SCHEDULE_DATE
    }
    
    override func descriptionEntity() -> String {
        return ""   // Intentionally left blank
    }
    
}
