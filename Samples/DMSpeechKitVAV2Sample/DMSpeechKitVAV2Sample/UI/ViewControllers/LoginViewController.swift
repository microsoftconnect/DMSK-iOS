//
//  LoginViewController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    let vaManager = VAManagerImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERNAME_KEY)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            errorMessageLabel.isHidden = false
            return
        }
        storeUsername(username)
        // Initialize session once username is available
        vaManager.initialize()
        showHomeScreen()
    }
}

extension LoginViewController {
    private func storeUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: Constants.USERDEFAULTS_USERNAME_KEY)
    }
    
    private func showHomeScreen() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.loadHomeScreen()
        }
    }
}
