//
//  ShowMeItemFactory.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class ShowMeItemFactory {
    static func createShowMeItem(_ dialogResult: DialogResult?) -> OtherItem {
        switch dialogResult?.intent {
        case Constants.INTENT_SHOW_LAB_CLASS_RESULTS:
            return ShowLabClassResultItem(dialogResult)
        case Constants.INTENT_SHOW_MEDICATION_RESULTS:
            return ShowMedicationResultsItem(dialogResult)
        case Constants.INTENT_SHOW_MEDICATION_CLASS_RESULTS:
            return ShowMedicationClassResultsItem(dialogResult)
        case Constants.INTENT_SHOW_MEDICATION_TIME:
            return ShowMedicationTimeItem(dialogResult)
        case Constants.INTENT_SHOW_MEDICATION_CLASS_TIME:
            return ShowMedicationClassTimeItem(dialogResult)
        case Constants.INTENT_SHOW_PATIENT_ALLERGIES:
            return ShowPatientAllergiesItem(dialogResult)
        case Constants.INTENT_SHOW_PATIENT_LAST_VISIT:
            return ShowPatientLastVisitItem(dialogResult)
        case Constants.INTENT_SHOW_PATIENT_VITALS:
            return ShowPatientVitalsItem(dialogResult)
        case Constants.INTENT_SHOW_PATIENT:
            return ShowPatientItem(dialogResult)
        case Constants.INTENT_SHOW_PATIENT_LOCATION:
            return ShowPatientLocationItem(dialogResult)
        case Constants.INTENT_SHOW_SCHEDULE:
            return ShowScheduleItem(dialogResult)
        default:
            return OtherItem(dialogResult)
        }
    }
}
