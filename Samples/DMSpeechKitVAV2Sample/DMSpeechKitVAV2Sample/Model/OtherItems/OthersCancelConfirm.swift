//
//  OthersCancelConfirm.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class OthersCancelConfirm: OtherItem {

    override func titleEntity() -> String {
        return EntitiesUtil.ENTITY_CANCELCONFIRM_TYPE
    }
    
    override func descriptionEntity() -> String {
        return EntitiesUtil.ENTITY_CANCEL_CONFIRM
    }
    
}
