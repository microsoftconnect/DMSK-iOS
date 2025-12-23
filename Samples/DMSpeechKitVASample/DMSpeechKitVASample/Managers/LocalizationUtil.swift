//
//  Localizable.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

extension String {
    /**
     Utility to avoid writing NSLocalizedString() everytime we use a string
     */
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
