//
//  Medication.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.


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

    init(_ eventDetail: EventDetail?) {
        super.init(title: "")
        self.medicationName = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_MEDICATION_NAME, eventDetail?.nluResult)
        self.dosage = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_DOSAGE_AMOUNT, eventDetail?.nluResult)
        self.dosageUnit = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_DOSAGE_UNIT, eventDetail?.nluResult)
        self.frequency = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_FREQUENCY, eventDetail?.nluResult)
        self.duration = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_DURATION_AMOUNT, eventDetail?.nluResult)
        self.durationUnit = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_DURATION_UNIT, eventDetail?.nluResult)
        let refill = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_REFILL, eventDetail?.nluResult)
        if refill.count > 0 {
            self.refill = refill + Constants.UNIT_REFILLS
        }
        self.prn = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_PRN, eventDetail?.nluResult)
    }

}
