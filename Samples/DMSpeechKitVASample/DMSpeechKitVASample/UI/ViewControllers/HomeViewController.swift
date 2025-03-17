//
//  ViewController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var currentDataProvider: CellDataProvider?
    var vuiController: NUSAVuiController?
    let intentManager: IntentManager = IntentManagerImpl.shared
    let vaManager: VAManager = VAManagerImpl.shared
    let notesController = NotesViewController.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    // Initializes the table view of Home screen
    private func initializeTableView() {
        self.tableView.tableFooterView = UIView()
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        headerView.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = headerView
    }
    
    // Initializes the VUI controller
    private func initializeVuiController() {
        vuiController = NUSAVuiController(view: self.view, andDisableSpeechViews: true)
        vuiController?.synchronizeWithView()
    }

    // Initializes the VUI controller
    private func initializeVA() {
        vaManager.initializeVirtualAssistant()
    }
    
    private func focusOnNotesScreen() -> Bool {
        var focusSet = false
        if notesController.isNotesActive() != false {
            notesController.syncResponder()
            focusSet = true
        }
        return focusSet
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        vaManager.vaDelegate(self)
        intentManager.intentDelegate(self)
        intentManager.setInitialScreen(type: ScreenType.HOME)
        initializeTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeVA()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SEGUE_ID_DICTATION {
            // Enable dictation
            if let destinationViewController = segue.destination as? NotesViewController {
                destinationViewController.enableRecording = true
            }
        }
    }
    
    // Action to show Help Screen
    @IBAction func helpButtonPressed(_ sender: Any) {
        showHelpScreen()
    }
    
    // Action to show Setting Screen 
    @IBAction func settingButtonPressed(_ sender: Any) {
        showSettingsScreen()
    }
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataProvider!.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentDataProvider!.providerType() == ScreenType.HOME {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_HOME)
            return cell!
        } else if currentDataProvider!.providerType() == ScreenType.MEDICATION {
            let medication = currentDataProvider!.data(forRow: indexPath.row) as! MedicationItem
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_MEDICATION) as? MedicationItemCell
            cell?.updateData(medication)
            return cell!
        } else if currentDataProvider!.providerType() == ScreenType.MESSAGES {
            let other = currentDataProvider!.data(forRow: indexPath.row) as! MessageItem
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_MESSAGE) as? MessageItemCell
            cell?.updateData(other)
            return cell!
        } else if currentDataProvider!.providerType() == ScreenType.REMINDER {
            let reminder = currentDataProvider!.data(forRow: indexPath.row) as! ReminderItem
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_REMINDER) as? ReminderItemCell
            cell?.updateData(reminder)
            return cell!
        } else if currentDataProvider!.providerType() == ScreenType.OTHER {
            let other = currentDataProvider!.data(forRow: indexPath.row) as! OtherItem
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_OTHER) as? OtherItemCell
            cell?.updateData(other)
            return cell!
        } else if currentDataProvider!.providerType() == ScreenType.SHOWME {
            let other = currentDataProvider!.data(forRow: indexPath.row) as! OtherItem
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ID_OTHER) as? OtherItemCell
            cell?.updateData(other)
            return cell!
        } else {
            fatalError("Type of screen is wrong")
        }
    }
}

// MARK: IntentDelegate
extension HomeViewController: IntentDelegate {
    func showScreen(type: ScreenType) {
        Logger.log("Show screen type \(type.title)\n")
        self.navigationController?.popToRootViewController(animated: false)
        if type == ScreenType.NOTES {
            showNotesScreen()
        } else {
            self.title = type.title
            currentDataProvider = intentManager.getProviderType(type)
            tableView.reloadData()
        }
    }
    
    // Shows Help screen
    func showHelp() {
        Logger.log("Show Help")
        self.navigationController?.popToRootViewController(animated: false)
        showHelpScreen()
    }
    
    // Shows Setting screen
    func showSettings() {
        Logger.log("Show Settings")
        self.navigationController?.popToRootViewController(animated: false)
        showSettingsScreen()
    }
    
    // Show the Notes screen and starts Dictation
    func startDictation() {
        Logger.log("Start dictation")
        self.navigationController?.popToRootViewController(animated: false)
        showNotesScreenAndStartDictation()
    }
}

// MARK: VADelegate
extension HomeViewController: VADelegate {
    // Showing alert message when DMVA initialization fails
    func onVAInitializationFailed(withError error: String, message: String) {
        let toast = UIAlertController(title: error, message: message, preferredStyle: .alert)
        present(toast, animated: true) {
            Timer.scheduledTimer(withTimeInterval: Constants.TIME_INTERVAL, repeats: false, block: { (_) in
                toast.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func onVAInitializationSucceeded() {
        if focusOnNotesScreen() != true {
            self.initializeVuiController()
        }
    }
}

// MARK: Utility
extension HomeViewController {
    private func showHelpScreen() {
        performSegue(withIdentifier: Constants.SEGUE_ID_HELP, sender: nil)
    }
    
    private func showSettingsScreen() {
        performSegue(withIdentifier: Constants.SEGUE_ID_SETTINGS, sender: nil)
    }
    
    private func showNotesScreen() {
        performSegue(withIdentifier: Constants.SEGUE_ID_NOTES, sender: nil)
    }
    
    private func showNotesScreenAndStartDictation() {
        performSegue(withIdentifier: Constants.SEGUE_ID_DICTATION, sender: nil)
    }
}

