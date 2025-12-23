//
//  SettingsViewController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let settingsDataProvider = SettingsDataProviderImpl.shared
    var vuiController: NUSAVuiController?
    static let CELL_ID = "settings_property_cell"
    @IBOutlet weak var loggerTextView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.delegate = self
        updateTextViewAndScroll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loggerTextView.setVuiEnabled(false)
        initializeVuiController()
    }
    
    private func initializeVuiController() {
        vuiController = NUSAVuiController(view: self.view, andDisableSpeechViews: true)
        vuiController?.synchronizeWithView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Logger.delegate = nil
    }
    
    // Updates the textview and scrolls down to latest entry
    private func updateTextViewAndScroll() {
        let logs = Logger.getLoggerDump()
        loggerTextView.text = logs
        let location = logs.count - 1
        let bottom = NSMakeRange(location, 1)
        loggerTextView.scrollRangeToVisible(bottom)
    }
    
    // Copy the logger contents
    @IBAction func copyButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = Logger.getLoggerDump()
    }
}

// MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsDataProvider.getRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewController.CELL_ID) as? SettingsCell
        let setting = settingsDataProvider.getRow(at: indexPath.row)
        cell?.setSetting(setting: setting)
        return cell!
    }
    
}

// MARK: LoggerStateListener
extension SettingsViewController: LoggerStateListener {
    func loggerBufferUpdated() {
        updateTextViewAndScroll()
    }
}

