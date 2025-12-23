//
//  SceneDelegate.swift
//  DMSpeechKitVASample
//
//  Copyright © 2025 Nuance Communications Inc. All rights reserved.
//


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        VAManagerImpl.shared.reinitializeVA()
    }
    
    func loadHomeScreen() {
        let storyboard = UIStoryboard(name: Constants.MAIN_STORY_BOARD, bundle: nil)
        let homeNavController = storyboard.instantiateViewController(withIdentifier: Constants.HOMESCREEN_NAV_CONTROLLER) as! UINavigationController
        window?.rootViewController = homeNavController
        window?.makeKeyAndVisible()
    }
}
