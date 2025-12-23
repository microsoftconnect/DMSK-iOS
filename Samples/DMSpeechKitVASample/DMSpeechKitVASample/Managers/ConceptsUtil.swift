//
//  ConceptsUtil.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

final class ConceptsUtil {
    
    //Medication
    static let CONCEPT_MEDICATION_NAME  = "MEDICATION"          // e.g. Tylenol
    static let CONCEPT_DOSAGE_AMOUNT    = "DOSE_AMOUNT"         // e.g. 200
    static let CONCEPT_DOSAGE_UNIT      = "DOSE_UNITS"          // e.g. milligrams
    static let CONCEPT_FREQUENCY        = "FREQUENCY_STRING"    // e.g. 3x daily
    static let CONCEPT_DURATION_UNIT    = "DURATION_UNITS"      // e.g. week
    static let CONCEPT_DURATION_AMOUNT  = "DURATION_AMOUNT"     // e.g. 1 (week)
    static let CONCEPT_REFILL           = "REFILL_AMOUNT"
    static let CONCEPT_PRN              = "PRN_ASNEEDED"
    static let CONCEPT_ITEM_DYNAMIC     = "SHOW_ITEM_DYNAMIC"   // e.g. Tylenol
    
    //Reminder
    static let CONCEPT_TASK_DESCRIPTION = "TASK_DESCRIPTION"    // e.g. Call Vivek
    static let CONCEPT_TASK_DATE        = "TASK_DATE"
    
    //Prompt
    static let CONCEPT_FREE_TEXT        = "FREE_TEXT"
    
    //Others
    static let CONCEPT_TEST_DESCRIPTION         = "LAB_CLASS_TEST"              // dmvaShowLabClassResults
    static let CONCEPT_TEST_TIMEFRAME           = "TIMEFRAME"                   // dmvaShowLabClassResults
    static let CONCEPT_MEDICATION_RESULT        = "MEDICATION"                  // dmvaShowMedicationResults
    static let CONCEPT_MEDICATION_RESULT_CLASS  = "MEDICATION_CLASS_DYNAMIC"    // dmvaShowMedicationClassResults
    static let CONCEPT_MEDICATION_TIME          = "MEDICATION"                  // dmvaShowMedicationTime
    static let CONCEPT_MEDICATION_TIME_CLASS    = "MEDICATION_CLASS_DYNAMIC"    // dmvaShowMedicationClassTime
    static let CONCEPT_PATIENT_ALLERGIES        = "ALLERGIES"                   // dmvaShowPatientAllergies
    static let CONCEPT_PATIENT_ALLERGIES_MEDS   = "SAID_MEDS"                   // dmvaShowPatientAllergies
    static let CONCEPT_PATIENT_VITALS           = "VITALS_DYNAMIC"              // dmvaShowPatientVitals
    static let CONCEPT_TELL_ITEM                = "TELL_ITEM_DYNAMIC"           // dmvaTellItem
    static let CONCEPT_TELL_ITEM_TIME           = "TIMEFRAME"                   // dmvaTellItem
    static let CONCEPT_SHOW_PATIENT_TIMEFRAME   = "TIMEFRAME"                   // dmvaShowPatient
    static let CONCEPT_SHOW_SCHEDULE_DATE       = "SCHEDULE_DATE"               // dmvaShowSchedule
    static let CONCEPT_CANCELCONFIRM_TYPE       = "APPT_TYPE"                   // dmvaCancelOrConfirm
    static let CONCEPT_CANCEL_CONFIRM           = "CANCEL_CONFIRM"              // dmvaCancelOrConfirm
    static let CONCEPT_SCHEDULE_SEARCH_TYPE     = "APPT_TYPE"                   // dmvaScheduleSearch
    static let CONCEPT_CALL_RECIPIENT           = "RECIPIENT_DYNAMIC"           // dmvaCall
    static let CONCEPT_CALL_TITLE               = "TITLE"                       // dmvaCall
    static let CONCEPT_MEMBER_DYNAMIC           = "MEMBER_NAME_DYNAMIC"         // dmvaMemberLookup
    static let CONCEPT_MEMBER_ID                = "MEMBER_ID"                   // dmvaMemberLookup
    static let CONCEPT_ITEM_NAME                = "ITEM_NAME_INLINE"            // dmvaListSelection
    static let CONCEPT_POSITION_ORDINAL         = "POSITION_ORDINAL"            // dmvaListSelection
    static let CONCEPT_NAVIGATION_DIRECTION     = "NAVIGATION_DIRECTION"        // dmvaListNavigation
    static let CONCEPT_OTHER_NOTES              = "NOTES"                       // dmvaNote
    
    //Message
    static let CONCEPT_MESSAGE_RECIPIENT = "RECIPIENT_DYNAMIC"  // e.g. Bob Martin
    static let CONCEPT_MESSAGE_TEXT      = "MESSAGE"            // e.g. Bring cake
    
    private init() { }
    
    public static func get(conceptName: String, _ dialogResult: DialogResult?) -> String {
        guard let concepts = dialogResult?.tasks?.last?.concepts else {
            return ""
        }
        for concept in concepts {
            if concept.name == conceptName {
                if concept.values?.count ?? 0 > 0 && concept.values?[0].value != nil {
                    return (concept.values?[0].value)!
                }
                break
            }
        }
        return ""
    }
    
    public static func set(values: [Value], conceptName: String, dialogResult: DialogResult?) {
        guard let concepts = dialogResult?.tasks?.last?.concepts else {
            return
        }
        for concept in concepts {
            if concept.name == conceptName {
                concept.values = values
            }
        }
    }

    public static func getConcept(conceptName: String, _ dialogResult: DialogResult?) -> [Concept]? {
        guard let concepts = dialogResult?.tasks?.last?.concepts else {
            return nil
        }
        for concept in concepts {
            if concept.name == conceptName {
                return concept.concepts
            }
        }
        return nil
    }
}
