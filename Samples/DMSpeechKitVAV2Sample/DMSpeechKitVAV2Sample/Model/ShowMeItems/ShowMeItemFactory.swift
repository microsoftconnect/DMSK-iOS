//
//  ShowMeItemFactory.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMeItemFactory {
    static func createShowMeItem(_ eventDetail: EventDetail?) -> OtherItem {
        switch eventDetail?.nluResult.intent {
        case Constants.INTENT_SHOW_LAB_CLASS_RESULTS,
             Constants.INTENT_SHOW_RESULTS:
            return ShowLabClassResultItem(eventDetail)
        case Constants.INTENT_SHOW_MEDICATION_RESULTS:
            return ShowMedicationResultsItem(eventDetail)
        case Constants.INTENT_SHOW_MEDICATION_CLASS_RESULTS:
            return ShowMedicationClassResultsItem(eventDetail)
        case Constants.INTENT_SHOW_MEDICATION_TIME:
            return ShowMedicationTimeItem(eventDetail)
        case Constants.INTENT_SHOW_MEDICATION_CLASS_TIME:
            return ShowMedicationClassTimeItem(eventDetail)
        case Constants.INTENT_SHOW_PATIENT_ALLERGIES:
            return ShowPatientAllergiesItem(eventDetail)
        case Constants.INTENT_SHOW_PATIENT_LAST_VISIT:
            return ShowPatientLastVisitItem(eventDetail)
        case Constants.INTENT_SHOW_PATIENT_VITALS:
            return ShowPatientVitalsItem(eventDetail)
        case Constants.INTENT_SHOW_PATIENT:
            return ShowPatientItem(eventDetail)
        case Constants.INTENT_SHOW_PATIENT_LOCATION:
            return ShowPatientLocationItem(eventDetail)
        case Constants.INTENT_SHOW_SCHEDULE:
            return ShowScheduleItem(eventDetail)
        default:
            return OtherItem(eventDetail)
        }
    }
}
