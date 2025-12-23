//
//  OthersLabCLassResult.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowLabClassResultItem: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_TEST_DESCRIPTION
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_TEST_TIMEFRAME
    }
    
}
