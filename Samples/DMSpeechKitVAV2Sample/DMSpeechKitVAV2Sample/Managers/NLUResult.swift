//
//  NLUResult.swift
//  DMSpeechKitVASample
//
//  Copyright © 2020 Nuance Communications Inc. All rights reserved.
//

import Foundation

class NLUResult: Codable {
    var literal: String?
    var nluId: String?
    var interpretations: [Interpretation]?
}

class Interpretation: Codable {
    var multiIntentInterpretation: MultiIntentInterpretation?
}

class MultiIntentInterpretation: Codable {
    var root: Root?
}

class Root: Codable {
    var intent: Intent?
}

class Intent: Codable {
    var name: String?
    var literal: String?
    var children: [IntentChild]?
}

class IntentChild: Codable {
    var entity: Entity?
}

class Entity: Codable {
    var name: String?
    var literal: String?
    var stringValue: String?
    var children: [IntentChild]?
    var structValue: StructValue?
}

class StructValue: Codable {
    var nuance_CALENDAR: NuanceCalendar?
    var nuance_CALENDAR_RANGE: NuanceCalendarRange?
}

class NuanceCalendarRange: Codable {
    var nuance_CALENDAR_RANGE_START: NuanceCalendarRangeStart?
    var nuance_CALENDAR_RANGE_END: NuanceCalendarRangeStart?
}

class NuanceCalendarRangeStart: Codable {
    var nuance_CALENDAR: NuanceCalendar?
}

class NuanceCalendar: Codable {
    var nuance_DATE: NuanceDate?
    var nuance_TIME: NuanceTime?
}

class NuanceDate: Codable {
    var nuance_DATE_ABS: NuanceDateAbs?
    var nuance_DATE_REL: NuanceDateRel?
}

class NuanceTime: Codable {
    var nuance_TIME_ABS: NuanceTimeAbs?
    var nuance_TIME_REL: NuanceTimeRel?
}

class NuanceDateAbs: Codable {
    var nuance_DAY: Int?
    var nuance_MONTH: Int?
    var nuance_YEAR: Int?
}

class NuanceDateRel: Codable {
    var nuance_STEP: String?
    var nuance_INCREMENT: Int?
    var nuance_REFERENCE: NuanceCalendar?
    var nuance_DAY_OF_WEEK: Int?
}

class NuanceTimeRel: Codable {
    var nuance_STEP: String?
    var nuance_INCREMENT: Int?
    var nuance_REFERENCE: NuanceCalendar?
}

class NuanceTimeAbs: Codable {
    var nuance_AMPM: String?
    var nuance_HOUR: Int?
    var nuance_MINUTE: Int?
    var nuance_MODIFIER: String?
}

extension NLUResult {
    
    var intent: String? {
        get {
            return interpretations?.last?.multiIntentInterpretation?.root?.intent?.name
        }
    }
    
    var entityStringValue: String? {
        get {
            return interpretations?.last?.multiIntentInterpretation?.root?.intent?.children?.last?.entity?.stringValue
        }
    }
    
    var isDictationRequested: Bool {
        get {
            return intent == Constants.INTENT_DOCUMENT_NOTES
        }
    }
    
    var entities: [IntentChild]? {
        get {
            return interpretations?.last?.multiIntentInterpretation?.root?.intent?.children
        }
    }
    
    var screenType: ScreenType? {
        get {
            switch intent {
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
                 Constants.INTENT_SHOW_RESULTS,
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
                let item = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_ITEM_DYNAMIC, self)
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
    
    func taskDateString() -> String? {
        var entity: Entity? = nil
        guard let interpretations = interpretations else {
            return nil
        }
        if let entities = interpretations[0].multiIntentInterpretation?.root?.intent?.children {
            for aEntity in entities {
                if aEntity.entity?.name == "TASK_DATE" || aEntity.entity?.name == "SCHEDULE_DATE" {
                    entity = aEntity.entity
                    break
                }
            }
        }
        if let entity = entity {
            guard let entityChildren = entity.children else {
                return nil
            }
            let calendar = entityChildren[0].entity?.structValue
            if let calendar = calendar {
                let jsonData = try! JSONEncoder().encode(calendar)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                return jsonString
            }
        }
        return nil
    }
}
