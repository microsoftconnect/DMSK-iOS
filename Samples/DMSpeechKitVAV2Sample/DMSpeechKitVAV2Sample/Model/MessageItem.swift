//
//  MessageItem.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class MessageItem: Model {
    var recipient: String?
    var message: String?
    
    init(_ eventDetail: EventDetail?) {
        super.init(title: "")
        let recipientEntity = EntitiesUtil.ENTITY_MESSAGE_RECIPIENT
        self.recipient = recipientEntity + ": " + EntitiesUtil.getEntityValue(entityName: recipientEntity, eventDetail?.nluResult)
        let messageEntity = EntitiesUtil.ENTITY_MESSAGE_TEXT
        self.message = messageEntity + ": " + EntitiesUtil.getEntityValue(entityName: messageEntity, eventDetail?.nluResult)
    }
    
}
