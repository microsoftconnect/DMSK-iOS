//
//  HelpViewController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {

    var vuiController: NUSAVuiController?
    @IBOutlet weak var webView: WKWebView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and Load Help page
        let url = Bundle.main.url(forResource: Constants.HELP_FILE_NAME, withExtension: Constants.HELP_FILE_EXT)
        webView?.navigationDelegate = self
        webView?.loadFileURL(url!, allowingReadAccessTo: url!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeVuiController()
    }
    
    private func initializeVuiController() {
        vuiController = NUSAVuiController(view: self.view, andDisableSpeechViews: true)
        vuiController?.synchronizeWithView()
    }
}

// MARK: WKNavigationDelegate
extension HelpViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
