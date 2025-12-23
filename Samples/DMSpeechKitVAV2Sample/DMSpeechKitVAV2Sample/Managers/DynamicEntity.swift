//
//  DynamicEntity.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class DynamicEntity {
    public let name: String
    public let jsonString: String
    public var uploaded = false
    
    private init(withName name: String, jsonString: String) {
        self.name = name
        self.jsonString = jsonString
    }
    
    // Items e.g. Logs, Settings, Home etc
    private static let ITEMS_DC = DynamicEntity(withName: Constants.DYNAMIC_ENTITIES_ITEMS_NAME,
                                                 jsonString: Constants.DYNAMIC_ENTITIES_ITEMS_JSON)
    // Recipient e.g. Alice, Bob, Sarah etc
    private static let RECIPIENTS_DC = DynamicEntity(withName: Constants.DYNAMIC_ENTITIES_RECIPIENT_NAME,
                                                      jsonString: Constants.DYNAMIC_ENTITIES_RECIPIENT_JSON)
    // Notes e.g. Exam, Physician
    private static let NOTES_DC = DynamicEntity(withName: Constants.DYNAMIC_ENTITIES_NOTES_NAME,
                                                 jsonString: Constants.DYNAMIC_ENTITIES_NOTES_JSON)

    public static let DYNAMIC_ENTITIES = [ITEMS_DC, RECIPIENTS_DC, NOTES_DC]
}
