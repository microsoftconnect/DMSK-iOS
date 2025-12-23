//
//  PlainNavigationController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class PlainNavigationController: UINavigationController {
    // Disable animation when back button is pressed
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: false)
    }
}
