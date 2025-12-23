//
//  VAManager.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

protocol VAManager {
    /**
     Initialize audio session at the launch of the app
     */
    func initialize()
    
    /**
     Do needed re-init when the app returns from the background
     */
    func reinitializeVA()
    
    /**
     Perform the cleanup e.g. clear dynamic concepts, close audio session & VA controller
     */
    func cleanUp()
    
    /**
     Send text to the DMVA to start or continue a dialog
     */
    func sendText(_ text: String)
    
    /**
     Initialize VA controller
     */
    func initializeVirtualAssistant()
    
    /**
     Set the VA delegate
     */
    func vaDelegate(_ delegate: VADelegate)
}

class VAManagerImpl: NSObject, VAManager {
    static let shared: VAManager = VAManagerImpl(intentManager: IntentManagerImpl.shared)
    let intentManager: IntentManager
    var orderMedicationDialogResult: DialogResult?
    var createTaskDialogResult: DialogResult?
    var raisePromptForChoice: Bool
    var raisePromptForFreeText: Bool
    weak var delegate: VADelegate?
    
    private init(intentManager: IntentManager) {
        self.intentManager = intentManager
        orderMedicationDialogResult = nil
        createTaskDialogResult = nil
        raisePromptForChoice = false
        raisePromptForFreeText = false
    }
    
    func initialize() {
        initializeSession()
    }
    
    func cleanUp() {
        cleanUpDynamicConcepts()
        cleanUpSession()
        cleanUpVAController()
    }
    
    func sendText(_ text: String) {
        Logger.log("Sending text: \(text)")
        NUSAVirtualAssistantController.shared().sendText(text)
    }
    
    // Provided text is played
    private func startSpeaking(_ text: String) {
        Logger.log("TTS: \(text)\n")
        NUSASession.shared().startSpeaking(text)
    }
    
    private func initializeSession() {
        NUSASession.shared().delegate = self
        NUSASession.shared().open(forApplication: Setting.APP_NAME.value,
                                  partnerGuid: Constants.DEFAULT_PARTNER_GUID,
                                  licenseGuid: Constants.DEFAULT_ORG_TOKEN,
                                  userId: UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERNAME_KEY)!)
    }
    
    func initializeVirtualAssistant() {
        initializeVA()
    }
    
    private func initializeVA() {
        // Initializing VA
        NUSAVirtualAssistantController.shared().delegate = self
        PermissionUtil.requestMicrophonePermissionAndExecute {
            NUSAVirtualAssistantController.shared().open(withModel: Setting.MODEL_ID.value)
        }
    }
    
    private func cleanUpDynamicConcepts() {
        NUSAVirtualAssistantController.shared().clearAllUploadedConceptValues()
    }
    
    private func cleanUpSession() {
        NUSASession.shared().delegate = nil
        NUSASession.shared().close()
    }
    
    private func cleanUpVAController(){
        NUSAVirtualAssistantController.shared().delegate = nil
        NUSAVirtualAssistantController.shared().close()
    }
    
    func reinitializeVA() {
        // Re-init VA after returning to foreground
        initializeVA()
    }
    
    internal func vaDelegate(_ delegate: VADelegate) {
        self.delegate = delegate
    }
    
}

extension VAManagerImpl: NUSAVirtualAssistantControllerDelegate {
    
    private func handleDialogResult(_ dialogResult: DialogResult?) {
        if (dialogResult?.intent) != nil {
            if(dialogResult?.intent == Constants.INTENT_ORDER_MEDICATION) {
                handleOrderMedication(dialogResult)
            } else if (dialogResult?.intent == Constants.INTENT_PROMPT_CHOICE) {
                handlePromptForChoice(dialogResult)
            } else if (dialogResult?.intent == Constants.INTENT_REMINDERS) {
                handleCreateTask(dialogResult)
            } else if (dialogResult?.intent == Constants.INTENT_PROMPT_FREE_TEXT) {
                handlePromptForFreeText(dialogResult)
            } else {
                intentManager.intentUpdate(dialogResult)
            }
        }
    }
    
    private func handleOrderMedication(_ dialogResult: DialogResult?) {
        orderMedicationDialogResult = dialogResult;
        raisePromptForChoice = true
        startSpeaking(Constants.PROMPT_CHOICE_TTS)
    }
    
    private func handlePromptForChoice(_ dialogResult: DialogResult?) {
        if(dialogResult?.taskConceptValue == Constants.PROMPT_CHOICE_COMPLETE) {
            intentManager.intentUpdate(orderMedicationDialogResult)
            orderMedicationDialogResult=nil;
        }
    }
    
    private func handleCreateTask(_ dialogResult: DialogResult?) {
        if(ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_TASK_DESCRIPTION, dialogResult) == "") {
            createTaskDialogResult = dialogResult
            raisePromptForFreeText = true
            startSpeaking(Constants.PROMPT_FREE_TEXT_TTS)
        } else {
            intentManager.intentUpdate(dialogResult)
        }
    }
    
    private func handlePromptForFreeText(_ dialogResult: DialogResult?) {
        let value = ConceptsUtil.get(conceptName: ConceptsUtil.CONCEPT_FREE_TEXT, dialogResult)
        if(value != "") {
            let item = Value()
            item.literal = value
            item.value = value
            ConceptsUtil.set(values: [item], conceptName: ConceptsUtil.CONCEPT_TASK_DESCRIPTION, dialogResult: createTaskDialogResult)
            intentManager.intentUpdate(createTaskDialogResult)
            createTaskDialogResult=nil
        }
    }
    
    private func processResultString(_ result: String!) {
        if let jsonData = result.data(using: .utf8 ) {
            let dialogResult = try? JSONDecoder().decode(DialogResult.self, from: jsonData)
            handleDialogResult(dialogResult)
        }
    }
    
    private func uploadDynamicConcepts() {
        for dynamicConcept in DynamicConcept.DYNAMIC_CONCEPTS {
            if !dynamicConcept.uploaded {
                let errorCode = NUSAVirtualAssistantController.shared().uploadValues(forConcept: dynamicConcept.name,
                                                                                     conceptValues: dynamicConcept.jsonString) { (error) in
                    if let error = error {
                        Logger.log("Error uploading Dynamic concept: \(dynamicConcept.name), error: \(error.localizedDescription)")
                    } else {
                        Logger.log("Dynamic concept successfully uploaded: \(dynamicConcept.name)")
                    }
                }
                Logger.log("Trying to upload Dynamic concept \(dynamicConcept.name): \(errorCode)")
                dynamicConcept.uploaded = (errorCode == NUSAVirtualAssistantErrorCodeNoError)
            }
        }
    }
    
    func nluResult(_ result: String!, errorCode: NUSAVirtualAssistantErrorCode, message: String!) {
        Logger.log("NLU Result: \(result ?? "EMPTY")")
        processNluResult(result)
    }
    
    internal func dialogResult(_ result: String!, errorCode: NUSAVirtualAssistantErrorCode, message: String!) {
        if errorCode == NUSAVirtualAssistantErrorCodeNoError {
            Logger.log("Event : Dialog Result \nMessage : \(message ?? "EMPTY")\nResult : \(result ?? "EMPTY")\n")
        } else {
            let errorString = getErrorDescription(errorCode)
            Logger.log("Event : Dialog Result \nError : \(errorString)\nMessage : \(message ?? "EMPTY")\nResult : \(result ?? "EMPTY")\n")
        }
        
        // Diagnotic logs are also provided by the SDK, result = LOG in that case
        if result != nil && result != "LOG" {
            processResultString(result)
        }
    }
    
    internal func stateChanged(_ state: NUSAVirtualAssistantState, errorCode: NUSAVirtualAssistantErrorCode, message: String!) {
        if errorCode == NUSAVirtualAssistantErrorCodeNoError && state == NUSAVirtualAssistantStateOpened {
            Logger.log("\(Constants.STATE_CHANGE_SUCCESS)\n")
            // Upload dynamic concepts when VA is successfully initialized
            uploadDynamicConcepts()
            self.delegate?.onVAInitializationSucceeded()
        } else {
            let stateString = getStateDescription(state)
            let errorString = getErrorDescription(errorCode)
            Logger.log("Event : State Changed \nError : \(errorString)\nMessage : \(message ?? "EMPTY")\nState : \(stateString)\n")
            DispatchQueue.main.async {
                self.delegate?.onVAInitializationFailed(withError: errorString, message: (message ?? "EMPTY"))
            }
        }
    }
    
    internal func conceptResult(_ errorCode: NUSAVirtualAssistantErrorCode, message: String!) {
        if errorCode == NUSAVirtualAssistantErrorCodeNoError {
            Logger.log("\(Constants.CONCEPT_UPLOAD_SUCCESS)\n")
        } else {
            let errorString = getErrorDescription(errorCode)
            Logger.log("Event : Concept Result \nError : \(errorString)\nMessage : \(message ?? "EMPTY")\n")
        }
    }
    
    // Gives the virtual assistant state description
    private func getStateDescription(_ state: NUSAVirtualAssistantState) -> String {
        var stateName: String
        switch state {
        case NUSAVirtualAssistantStateOpened:
            stateName = Constants.STATE_OPEN
        case NUSAVirtualAssistantStateClosed:
            stateName = Constants.STATE_CLOSE
        default:
            stateName = Constants.STATE_UNKNOWN
        }
        return stateName
    }
    
    // Gives the virtual assistant error description
    private func getErrorDescription(_ errorCode: NUSAVirtualAssistantErrorCode) -> String {
        var errorDescription: String
        switch errorCode {
        case NUSAVirtualAssistantErrorCodeNoError:
            errorDescription = Constants.NO_ERROR
        case NUSAVirtualAssistantErrorCodeConfigurationError:
            errorDescription = Constants.CONFIGURATION_ERROR
        case NUSAVirtualAssistantErrorCodeNetworkError:
            errorDescription = Constants.NETWORK_ERROR
        case NUSAVirtualAssistantErrorCodeServerError:
            errorDescription = Constants.SERVER_ERROR
        case NUSAVirtualAssistantErrorCodeApplicationStateError:
            errorDescription = Constants.APPLICATION_STATE_ERROR
        case NUSAVirtualAssistantErrorCodeParameterError:
            errorDescription = Constants.PARAMETER_ERROR
        case NUSAVirtualAssistantErrorCodeUnknownError:
            errorDescription = Constants.UNKNOWN_ERROR
        default:
            errorDescription = Constants.MISSING_ERROR
        }
        return errorDescription
    }
}

extension VAManagerImpl: NUSASessionDelegate {
    internal func sessionDidStopSpeaking() {
        if(raisePromptForChoice) {
            raisePromptForChoice = false
            NUSAVirtualAssistantController.shared().prompt(forChoice:Constants.PROMPT_CHOICE_STRING)
        } else if (raisePromptForFreeText) {
            raisePromptForFreeText = false
            NUSAVirtualAssistantController.shared().promptForFreeText()
        }
    }
}

