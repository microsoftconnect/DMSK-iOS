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
    
    init(_ dialogResult: DialogResult?) {
        super.init(title: "")
        let recipientC = ConceptsUtil.CONCEPT_MESSAGE_RECIPIENT
        self.recipient = recipientC + ": " + ConceptsUtil.get(conceptName: recipientC, dialogResult)
        let messageC = ConceptsUtil.CONCEPT_MESSAGE_TEXT
        self.message = messageC + ": " + ConceptsUtil.get(conceptName: messageC, dialogResult)
    }
    
}
