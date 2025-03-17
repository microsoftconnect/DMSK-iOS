//
//  Medication.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class MedicationItem: Model {
    var medicationName: String?
    var dosage: String?
    var dosageUnit: String?
    var frequency: String?
    var duration: String?
    var durationUnit: String?
    var refill: String?
    var prn: String?

    init(_ dialogResult: DialogResult?) {
        super.init(title: "")
        self.medicationName = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_MEDICATION_NAME, dialogResult)
        self.dosage = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_DOSAGE_AMOUNT, dialogResult)
        self.dosageUnit = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_DOSAGE_UNIT, dialogResult)
        self.frequency = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_FREQUENCY, dialogResult)
        self.duration = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_DURATION_AMOUNT, dialogResult)
        self.durationUnit = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_DURATION_UNIT, dialogResult)
        let refill = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_REFILL, dialogResult)
        if refill.count > 0 {
            self.refill = refill + Constants.UNIT_REFILLS
        }
        self.prn = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_PRN, dialogResult)
    }

}
