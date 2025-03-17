//
//  NLUResult.swift
//  DMSpeechKitVASample
//
//  Copyright © 2020 Nuance Communications Inc. All rights reserved.
//

import Foundation

class NLUResult: Codable {
    var literal: String?
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
