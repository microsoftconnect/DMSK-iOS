//
//  ReminderItemCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class ReminderItemCell: DataItemCell {
    
    @IBOutlet weak var reminderSubject: UILabel!
    @IBOutlet weak var reminderDate: UILabel!

    func updateData(_ data: ReminderItem) {
        populate(data: data.taskDescription, label: reminderSubject)
        // TODO: Once FLOR-7732 is resolved, uncomment the commented code and remove the following line
        reminderDate?.text = data.taskDate
        // populate(data: data.taskDate, label: reminderDate, mandatory: true)
    }

}
