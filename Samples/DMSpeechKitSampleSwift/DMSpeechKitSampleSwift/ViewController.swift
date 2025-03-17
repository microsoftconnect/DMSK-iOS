//
//  ViewController.swift
//  DMSpeechKitSampleSwift
//
//  Created by angela on 2014/08/11.
//  Copyright (c) 2014 Nuance. All rights reserved.
//

import UIKit

let kMyApplicationName="DMSpeechKitSampleSwift"

// Convenience defines used for opening the NUSASession instance and pass it the licensing
// information needed. Partner GUID and organization token will be made available to you via the
// Nuance order desk.
// It is ok to hard-code the partner GUID - should be "hidden" within your application,
// usually will not need to be changed.
let kMyPartnerGuid="ENTER_YOUR_PARTNER_GUID"

// THIS IS CUSTOMER SPECIFIC - MUST *NOT* BE HARD-CODED!
// THIS IS EQUIVALENT TO A LICENSE KEY - MUST BE KEPT SECRET FROM UNAUTHORIZED USERS!
// Make it configurable via user settings or download it from your server if you have a client-server app.
let kMyOrganizationToken="ENTER_YOUR_ORGANIZATION_TOKEN"

class ViewController: UIViewController, LoginViewControllerDelegate {
    var userLoggedIn = false
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !userLoggedIn {
            let loginController: LoginViewController! = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController;
            loginController.delegate = self;
            
            present(loginController, animated: true, completion: nil);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginViewController(_ controller: LoginViewController, userName: String) {
        self.dismiss(animated: true, completion: nil);
        userLoggedIn = true;
        
        // The loginViewController:didLoginUser message is sent to us once the user logged in via the
        // LoginViewController view presented to him at the start of the application. We will use the
        // user name as given in that view for licensing information passed to the Dragon Medical SpeechKit.
        NUSASession.shared().open(forApplication: kMyApplicationName, partnerGuid: kMyPartnerGuid, licenseGuid: kMyOrganizationToken, userId: userName)
    }
}

