//
//  DynamicConcepts.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class DynamicConcept {
    public let name: String
    public let jsonString: String
    public var uploaded = false
    
    private init(withName name: String, jsonString: String) {
        self.name = name
        self.jsonString = jsonString
    }
    
    // Items e.g. Logs, Settings, Home etc
    private static let ITEMS_DC = DynamicConcept(withName: Constants.DYNAMIC_CONCEPTS_ITEMS_NAME,
                                                 jsonString: Constants.DYNAMIC_CONCEPTS_ITEMS_JSON)
    // Recipient e.g. Alice, Bob, Sarah etc
    private static let RECIPIENTS_DC = DynamicConcept(withName: Constants.DYNAMIC_CONCEPTS_RECIPIENT_NAME,
                                                      jsonString: Constants.DYNAMIC_CONCEPTS_RECIPIENT_JSON)
    // Notes e.g. Exam, Physician
    private static let NOTES_DC = DynamicConcept(withName: Constants.DYNAMIC_CONCEPTS_NOTES_NAME,
                                                 jsonString: Constants.DYNAMIC_CONCEPTS_NOTES_JSON)
    
    // Names e.g. Adam Baker
    private static let NAMES_DC = DynamicConcept(withName: Constants.DYNAMIC_CONCEPTS_NAME_INLINE_NAME,
                                                 jsonString: Constants.DYNAMIC_CONCEPTS_NAME_INLINE_JSON)

    public static let DYNAMIC_CONCEPTS = [ITEMS_DC, RECIPIENTS_DC, NOTES_DC, NAMES_DC]
}
