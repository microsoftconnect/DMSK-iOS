//
//  OthersShowSchedule.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowScheduleItem: OtherItem {

    override func titleConcept() -> String {
        return ConceptsUtil.CONCEPT_SHOW_SCHEDULE_DATE
    }
    
    override func descriptionConcept() -> String {
        return ""   // Intentionally left blank
    }
    
}
