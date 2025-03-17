//
//  Reminder.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class Model {

    var title: String?
    
    init(title: String) {
        self.title = title
    }

}

class ReminderItem: Model {
    var taskDescription: String?
    var taskDate: String?

    init(_ eventDetail: EventDetail?) {
        super.init(title: "")
        let task = EntitiesUtil.ENTITY_TASK_DESCRIPTION
        self.taskDescription = task + ": " + EntitiesUtil.getEntityValue(entityName: task, eventDetail?.nluResult)
        let date = EntitiesUtil.ENTITY_TASK_DATE
        
        let dateTimeFormatter = DMVADateTimeFormatter(7, defaultMinute: 0, defaultSecond: 0, currentTimeAsDefaultValue: false, showTimeInDateValue: true)
        let entitiesObj = EntitiesUtil.getIntentArray(entityName: date, eventDetail?.nluResult)
        var resultString : String?
        if entitiesObj != nil {
            let jsonData = try! JSONEncoder().encode(entitiesObj)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            resultString = dateTimeFormatter?.getISO8601Format(fromJSONString: jsonString, timeZone: NSTimeZone.local)
            print("result: \(resultString!)")
        }
        self.taskDate = date + ": " + (resultString ?? "")
    }
    
}
