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

    init(_ dialogResult: DialogResult?) {
        super.init(title: "")
        let taskC = ConceptsUtil.CONCEPT_TASK_DESCRIPTION
        self.taskDescription = taskC + ": " + ConceptsUtil.get(conceptName: taskC, dialogResult)
        let dateC = ConceptsUtil.CONCEPT_TASK_DATE
        
        let dateTimeFormatter = DMVADateTimeFormatter(7, defaultMinute: 0, defaultSecond: 0, currentTimeAsDefaultValue: false, showTimeInDateValue: true)
        let conceptsObj = ConceptsUtil.getConcept(conceptName: dateC, dialogResult)
        var resultString : String?
        if conceptsObj != nil {
            let jsonData = try! JSONEncoder().encode(conceptsObj)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            resultString = dateTimeFormatter?.getISO8601Format(fromJSONString: jsonString, timeZone: NSTimeZone.local)
            print("result: \(resultString!)")
        }
        self.taskDate = dateC + ": " + (resultString ?? "")
    }
    
}
