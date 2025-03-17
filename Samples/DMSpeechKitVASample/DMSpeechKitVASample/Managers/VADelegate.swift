//
//  VADelegate.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol VADelegate: class {
    func onVAInitializationFailed(withError error: String, message: String)
    func onVAInitializationSucceeded()
}

