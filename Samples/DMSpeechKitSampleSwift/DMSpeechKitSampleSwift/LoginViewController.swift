//
//  LoginViewController.swift
//  DMSpeechKitSampleSwift
//
//  Created by angela on 2014/08/11.
//  Copyright (c) 2014 Nuance. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginViewController(_ controller: LoginViewController, userName: String);
}

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        var userName = ""
        
        if !userNameField.text!.isEmpty {
            userName = userNameField.text!;
        }
        else {
            userName = userNameField.placeholder!;
        }
        
        delegate.loginViewController(self, userName: userName);
    }
    
    @IBOutlet weak var userNameField: UITextField!
    
    var delegate: LoginViewControllerDelegate!
}


