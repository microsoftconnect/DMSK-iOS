//
//  DialogResult.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class DialogResult: Codable {
    var actions: [Action]?
    var tasks: [Task]?
    var literal: String?
}

class Action: Codable {
    var taskId: String?
    var key: String?
    var facets: [Facet]?
}

class Facet: Codable {
    var name: String?
    var value: String?
}

class Task: Codable {
    var id: String?
    var state: String?
    var concepts: [Concept]?
    var intent: String?
}

class Concept: Codable {
    var name: String?
    var values: [Value]?
    var concepts: [Concept]?
}

class Value: Codable {
    var literal: String?
    var value: String?
}

enum DialogState {
    case complete       // Complete, process(add to list etc) it
    case incomplete     // Dialog incomplete, tts
    case invalid        // Dialog invalid
    case aborted        // Dialog cancelled
}

// MARK: Adding derived properties
extension DialogResult {
    var state: DialogState {
        get {
            guard let tasksArray = tasks else {
                return .invalid
            }
            if tasksArray.count == 0 {
                return .invalid
            }
            if tasksArray.last?.state == Constants.RESPONSE_STRING_STATE_FINISHED {
                return .complete
            }
            if tasksArray.last?.state == Constants.RESPONSE_STRING_STATE_ABORTED {
                return .aborted
            }
            return .incomplete
        }
    }
    
    // Confirms whether multiple dialogs exist
    func hasMultipleDialogs() -> Bool {
        guard let tasksArray = tasks else {
            return false
        }
        if tasksArray.count >= 2 {
            return true
        }
        return false
    }
    
    var intent: String? {
        get {
            return tasks?.last?.intent
        }
    }
    
    var taskConceptValue: String? {
        get {
            return tasks?.last?.concepts?.last?.values?.last?.value
        }
    }
        
    var screenType: ScreenType? {
        get {
            let intentString = tasks?.last?.intent
            switch intentString {
            case Constants.INTENT_SHOW_HELP:
                return ScreenType.HELP
            case Constants.INTENT_ORDER_MEDICATION:
                return ScreenType.MEDICATION
            case Constants.INTENT_SEND_MESSAGE:
                return ScreenType.MESSAGES
            case Constants.INTENT_OTHERS_TELL_ME_ITEM,
                 Constants.INTENT_OTHERS_CANCEL_CONFIRM,
                 Constants.INTENT_OTHERS_SCHEDULE_SEARCH,
                 Constants.INTENT_OTHERS_CALL,
                 Constants.INTENT_OTHERS_RETRIEVE_MESSAGE,
                 Constants.INTENT_OTHERS_MEMBER_LOOKUP,
                 Constants.INTENT_OTHERS_MEMBER_CLOSE,
                 Constants.INTENT_OTHERS_REPEAT_TTS,
                 Constants.INTENT_OTHERS_LIST_SELECTION,
                 Constants.INTENT_OTHERS_LIST_NAVIGATION,
                 Constants.INTENT_OTHERS_NOTE:
                return ScreenType.OTHER
            case Constants.INTENT_SHOW_LAB_CLASS_RESULTS,
                 Constants.INTENT_SHOW_MEDICATION_RESULTS,
                 Constants.INTENT_SHOW_MEDICATION_CLASS_RESULTS,
                 Constants.INTENT_SHOW_MEDICATION_TIME,
                 Constants.INTENT_SHOW_MEDICATION_CLASS_TIME,
                 Constants.INTENT_SHOW_PATIENT_ALLERGIES,
                 Constants.INTENT_SHOW_PATIENT_LAST_VISIT,
                 Constants.INTENT_SHOW_PATIENT_VITALS,
                 Constants.INTENT_SHOW_PATIENT,
                 Constants.INTENT_SHOW_PATIENT_LOCATION,
                 Constants.INTENT_SHOW_SCHEDULE:
                return ScreenType.SHOWME
            case Constants.INTENT_REMINDERS:
                return ScreenType.REMINDER
            case Constants.INTENT_DOCUMENT_NOTES:
                return ScreenType.NOTES
            case Constants.INTENT_SHOW_ITEM:
                let item = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_ITEM_DYNAMIC, self)
                switch item {
                case Constants.ITEM_SHOW_HOME:
                    return ScreenType.HOME
                case Constants.ITEM_SHOW_LOGS, Constants.ITEM_SHOW_SETTINGS:
                    return ScreenType.SETTING
                case Constants.ITEM_SHOW_NOTES, Constants.ITEM_EXAM_NOTES, Constants.ITEM_PHYSICIAN_NOTES, Constants.ITEM_PROGRESS_NOTES, Constants.ITEM_ADMISSION_NOTES, Constants.ITEM_CARDIOLOGY_NOTES, Constants.ITEM_DISCHARGE_NOTES:
                    return ScreenType.NOTES
                default:
                    return ScreenType.OTHER
                }
            default:
                Logger.log("Not one of the supported intents, results may be wrong")
                return ScreenType.OTHER
            }
        }
    }
    
    // Check whether Dictation is requested
    var isDictationRequested: Bool {
        get {
            let intentString = tasks?.last?.intent
            return intentString == Constants.INTENT_DOCUMENT_NOTES
        }
    }
}

extension Array {
    func get(index: Int) -> Element? {
        if index >= 0 && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
