//
//  EventDetail.swift
//  DMSpeechKitVAV2Sample
//
//  Copyright © 2021 Nuance Communications Inc. All rights reserved.
//

import Foundation

// MARK: - EventDetail
class EventDetail: Codable {
    let status: Status
    let nluResult: NLUResult
}

// MARK: - Status
class Status: Codable {
    let message: String
    let resultCode: String
}
