//
//  SceneDelegate.swift
//  DMSpeechKitVAV2Sample
//
//  Copyright © 2025 Nuance Communications Inc. All rights reserved.
//


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let vaManager = VAManagerImpl.shared
    
    func loadHomeScreen() {
        let storyboard = UIStoryboard(name: Constants.MAIN_STORY_BOARD, bundle: nil)
        let homeNavController = storyboard.instantiateViewController(withIdentifier: Constants.HOMESCREEN_NAV_CONTROLLER) as! UINavigationController
        window?.rootViewController = homeNavController
        window?.makeKeyAndVisible()
    }
    
}
