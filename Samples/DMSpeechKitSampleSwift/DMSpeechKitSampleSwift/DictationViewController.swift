//
//  LoginViewController.swift
//  DMSpeechKitSampleSwift
//
//  Created by angela on 2014/08/11.
//  Copyright (c) 2014 Nuance. All rights reserved.
//

import UIKit

class DictationViewController: UIViewController, NUSASessionDelegate, NUSAVuiControllerDelegate {
    @IBOutlet weak var recordToggleButton: UIButton!
    @IBOutlet var vuiController: NUSAVuiController!
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Warning:
        // Releasing the vui controller in the viewDidUnload method will not work, as the
        // vui controller retains your UI view, preventing it from being unloaded by the
        // framework. Release the vui controller at an earlier point in time to allow the
        // runtime to unload your view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set up our record button
        recordToggleButton.setTitle("Record",  for: UIControl.State())
        recordToggleButton.setTitle("Stop", for: UIControl.State.selected)
        
        // Uncomment the code below if you want to create the NUSAVuiController instance
        // programmatically instead of via a NIB file. In case you create the NUSAVuiController
        // in this way, the view object (including all of its subviews) needs to be fully
        // loaded as the vui controller will inspect the view at the time it is created to
        // create the vui model that is used to speech-enable your UI view.
        //
        // Attention:
        // The current implementation connects the vui controller with our UI view in the
        // IF Builder XIB file (see DictationView.xib) for reference.
#if TEST
        vuiController =  NUSAVuiController(view: self.view)
#endif
        // In order to receive NUSASession delegate messages, set ourselves as the session
        // delegate. Doing so, will tell the NUSASession instance to send the start recording and
        // stop recording delegate messages. Doing so is optional and only needed if you want to
        // present a record toggle button in your UI that updates according to the recording state
        // of the NUSASession. 
        NUSASession.shared().delegate = self

        // Enabling named field navigation for the end user. Dragon Medical SpeechKit will automatically create
        // voice commands based on the vuiConceptName property set for speech enabled controls. E.g.
        // the vuiConceptName properties below will result in the user being able to say "go to reason for admission"
        // and "go to medical history" to set the focus to the editField and textView control. Sequential
        // voice navigation is enabled by default, e.g. the user will always be able to say "next field" and
        // "previous field".
        editField.setVuiConceptName("reason for admission")
        textView.setVuiConceptName("medical history")
        
        // create a command set and command placeholder
        let commandSet: NUSACommandSet? = NUSACommandSet(name: "show things", description: "show some things")
        commandSet?.createCommand("SHOW_ANIMALS", phrase:"show me <ANIMALS>", display:"", description:"show animals");
        commandSet?.createCommand("SPEAK_ANIMALS", phrase:"tell me <ANIMALS>", display:"", description:"speak animals");
        // create an alternative phrase
        commandSet?.createCommand("SPEAK_ANIMALS", phrase:"speak <ANIMALS>", display:"", description:"speak animals");
        let commandPlaceholder: NUSACommandPlaceholder? = NUSACommandPlaceholder(id:"ANIMALS", label:"animals")
        commandPlaceholder?.setValues(["DOGS", "CATS"], withSpokenForms: ["dogs", "cats"])
        // assign command set and placeholder to the vui controller
        vuiController.assignCommandSets([commandSet!])
        vuiController.assignCommandPlaceholders([commandPlaceholder!])
        // The vui controller must be synchronized to enable the application commands
        vuiController.synchronizeWithView()
        vuiController.delegate = self;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Release the vui controller instance, once it is no longer needed. Releasing the
        // vui controller frees speech recognition resources on the server and disconnects
        // from the service. If you do not release the vui controller on your own, the SDK
        // will do so once you create another vui controller in your application.
        vuiController = nil;
        
        // Also remove ourselves as the NUSASessions delegate
        NUSASession.shared().delegate = nil
        
        // We do not need to take care of recording, as the Dragon Medical SpeechKit will
        // automatically stop recording for us if it was still running at the time the vui
        // controller is released. 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func toggleRecordingAction(_ sender: AnyObject) {
        // Implement a simple toggle recording method. For simplicities sake, we use the selected
        // property of the record toggle button to decide which NUSASession method to call.
        if !recordToggleButton.isSelected {
            do {
                try NUSASession.shared().startRecording()
            } catch _ {
            }
        }
        else {
            NUSASession.shared().stopRecording()
        }
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func sessionDidStartRecording() {
        // This delegate message is sent in case recording was started by the user. Sending the startRecording: message
        // to the NUSASession instance does not send trigger this message. We react by changing the toggle record button
        // state.
        recordToggleButton.isSelected = true
    }
    
    func sessionDidStopRecording() {
        // This delegate message is sent in case recording was stopped by the user or in case of an error. Sending the
        // stopRecording message to the NUSASession instance does not trigger this message. We react by changing the toggle
        // record button state. In case an error occured, the user will be informed by the Dragon Medical SpeechKit.
        recordToggleButton.isSelected = false
    }
    
    func vuiControllerDidRecognizeCommand(_ id: String!, spokenPhrase: String!, placeholderValues: [AnyHashable: Any]!) {
        // This delegate message is sent in case a command was recognized
        // check the command id
        if id == "SHOW_ANIMALS" || id == "SPEAK_ANIMALS"
        {
            let title:String? = placeholderValues["ANIMALS"] as AnyObject? as? String
            var text: String!
            // check the command placeholder
            if title == "DOGS"
            {
                text = "poodle\npug\nsausage dog"
            }
            else
            {
                text = "lion\ntiger\ncougar"
            }
            // trigger different actions depending on the recognized command
            if id == "SHOW_ANIMALS"
            {
                let alert = UIAlertView(title: title, message: text, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                NUSASession.shared().startSpeaking(text)
            }
        }
    }
}


