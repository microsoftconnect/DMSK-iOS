//
//  MedicationItemCell.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class MedicationItemCell: DataItemCell {
    
    @IBOutlet weak var medicationTitle: UILabel!
    @IBOutlet weak var medicationDosage: UILabel!
    @IBOutlet weak var medicationFrequency: UILabel!
    @IBOutlet weak var medicationRefill: UILabel!
    @IBOutlet weak var medicationDuration: UILabel!
    @IBOutlet weak var medicationPRN: UILabel!
    
    func updateData(_ data: MedicationItem) {
        populate(data: data.medicationName, label: medicationTitle)
        populate(data: data.dosage, unit: data.dosageUnit, label: medicationDosage)
        populate(data: data.frequency, label: medicationFrequency)
        populate(data: data.duration, unit: data.durationUnit, label: medicationDuration)
        populate(data: data.refill, label: medicationRefill)
        populate(data: data.prn, label: medicationPRN)
    }
    
}
