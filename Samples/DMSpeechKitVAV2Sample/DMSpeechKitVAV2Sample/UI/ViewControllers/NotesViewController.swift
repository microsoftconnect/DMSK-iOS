//
//  NotesViewController.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class NotesViewController: UIViewController {
    
    var enableRecording = false
    var vuiController: NUSAVuiController?
    let notesTracker = NotesTrackerImpl.shared
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTextView()
        initializeVuiController()
        startDictationIfRequired()
    }
    
    private func initializeVuiController() {
        vuiController = NUSAVuiController(view: self.view)
        vuiController?.synchronizeWithView()
        notesTextView.becomeFirstResponder()
    }
    
    private func startDictationIfRequired() {
        if enableRecording {
            do {
                try NUSASession.shared().startRecording()
            } catch let error as NSError {
                print("Error \(error)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notesTracker.setNotes(notesTextView.text)
    }
    
    private func populateTextView() {
        notesTextView.text = notesTracker.notes()
    }
}
