//
//  AppDelegate.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let vaManager = VAManagerImpl.shared
    
    func loadHomeScreen() {
        let storyboard = UIStoryboard(name: Constants.MAIN_STORY_BOARD, bundle: nil)
        let homeNavController = storyboard.instantiateViewController(withIdentifier: Constants.HOMESCREEN_NAV_CONTROLLER) as! UINavigationController
        window?.rootViewController = homeNavController
        window?.makeKeyAndVisible()
    }
}

