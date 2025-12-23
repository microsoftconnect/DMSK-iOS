//
//  EntitiesUtil.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

final class EntitiesUtil {
    
    //Medication
    static let ENTITY_MEDICATION_NAME  = "MEDICATION"          // e.g. Tylenol
    static let ENTITY_DOSAGE_AMOUNT    = "DOSE_AMOUNT"         // e.g. 200
    static let ENTITY_DOSAGE_UNIT      = "DOSE_UNITS"          // e.g. milligrams
    static let ENTITY_FREQUENCY        = "FREQUENCY_STRING"    // e.g. 3x daily
    static let ENTITY_DURATION_UNIT    = "DURATION_UNITS"      // e.g. week
    static let ENTITY_DURATION_AMOUNT  = "DURATION_AMOUNT"     // e.g. 1 (week)
    static let ENTITY_REFILL           = "REFILL_AMOUNT"
    static let ENTITY_PRN              = "PRN_ASNEEDED"
    static let ENTITY_ITEM_DYNAMIC     = "SHOW_ITEM_DYNAMIC"   // e.g. Tylenol
    
    //Reminder
    static let ENTITY_TASK_DESCRIPTION = "TASK_DESCRIPTION"    // e.g. Call Sarah
    static let ENTITY_TASK_DATE        = "TASK_DATE"
    
    //Prompt
    static let ENTITY_FREE_TEXT        = "FREE_TEXT"
    
    //Others
    static let ENTITY_TEST_DESCRIPTION         = "LAB_CLASS_TEST"              // dmvaShowLabClassResults
    static let ENTITY_TEST_TIMEFRAME           = "TIMEFRAME"                   // dmvaShowLabClassResults
    static let ENTITY_MEDICATION_RESULT        = "MEDICATION"                  // dmvaShowMedicationResults
    static let ENTITY_MEDICATION_RESULT_CLASS  = "MEDICATION_CLASS_DYNAMIC"    // dmvaShowMedicationClassResults
    static let ENTITY_MEDICATION_TIME          = "MEDICATION"                  // dmvaShowMedicationTime
    static let ENTITY_MEDICATION_TIME_CLASS    = "MEDICATION_CLASS_DYNAMIC"    // dmvaShowMedicationClassTime
    static let ENTITY_PATIENT_ALLERGIES        = "ALLERGIES"                   // dmvaShowPatientAllergies
    static let ENTITY_PATIENT_ALLERGIES_MEDS   = "SAID_MEDS"                   // dmvaShowPatientAllergies
    static let ENTITY_PATIENT_VITALS           = "VITALS_DYNAMIC"              // dmvaShowPatientVitals
    static let ENTITY_TELL_ITEM                = "TELL_ITEM_DYNAMIC"           // dmvaTellItem
    static let ENTITY_TELL_ITEM_TIME           = "TIMEFRAME"                   // dmvaTellItem
    static let ENTITY_SHOW_PATIENT_TIMEFRAME   = "TIMEFRAME"                   // dmvaShowPatient
    static let ENTITY_SHOW_SCHEDULE_DATE       = "SCHEDULE_DATE"               // dmvaShowSchedule
    static let ENTITY_CANCELCONFIRM_TYPE       = "APPT_TYPE"                   // dmvaCancelOrConfirm
    static let ENTITY_CANCEL_CONFIRM           = "CANCEL_CONFIRM"              // dmvaCancelOrConfirm
    static let ENTITY_SCHEDULE_SEARCH_TYPE     = "APPT_TYPE"                   // dmvaScheduleSearch
    static let ENTITY_CALL_RECIPIENT           = "RECIPIENT_DYNAMIC"           // dmvaCall
    static let ENTITY_CALL_TITLE               = "TITLE"                       // dmvaCall
    static let ENTITY_MEMBER_DYNAMIC           = "MEMBER_NAME_DYNAMIC"         // dmvaMemberLookup
    static let ENTITY_MEMBER_ID                = "MEMBER_ID"                   // dmvaMemberLookup
    static let ENTITY_ITEM_NAME                = "ITEM_NAME_INLINE"            // dmvaListSelection
    static let ENTITY_POSITION_ORDINAL         = "POSITION_ORDINAL"            // dmvaListSelection
    static let ENTITY_NAVIGATION_DIRECTION     = "NAVIGATION_DIRECTION"        // dmvaListNavigation
    static let ENTITY_OTHER_NOTES              = "NOTES"                       // dmvaNote
    
    //Message
    static let ENTITY_MESSAGE_RECIPIENT = "RECIPIENT_DYNAMIC"  // e.g. Bob Martin
    static let ENTITY_MESSAGE_TEXT      = "MESSAGE"            // e.g. Bring cake
    
    private init() { }
    
    public static func getEntityValue(entityName: String, _ nluResult: NLUResult?) -> String {
        if let entities = nluResult?.entities {
            for entityDictionary in entities {
                if entityDictionary.entity?.name == entityName {
                    let value = entityDictionary.entity?.stringValue
                    if value?.count ?? 0 > 0 && value != nil {
                        return value!
                    }
                    else {
                        let value = entityDictionary.entity?.children?.last?.entity?.stringValue
                        if value?.count ?? 0 > 0 && value != nil {
                            return value!
                        }
                    }
                    break
                }
            }
        }
        return ""
    }

    public static func setEntity(value: String, entityName: String, nluResult: NLUResult?) {
        guard let entities = nluResult?.entities else {
            return
        }
        
        for entityDictionary in entities {
            if entityDictionary.entity?.name == entityName {
                entityDictionary.entity?.stringValue = value
            }
        }
    }
    public static func getIntentArray(entityName: String, _ nluResult: NLUResult?) -> [IntentChild]? {
        guard let entities = nluResult?.entities else {
            return nil
        }
        for entityDict in entities {
            if entityDict.entity?.name == entityName {
                return entityDict.entity?.children
            }
        }
        return nil
    }
}
