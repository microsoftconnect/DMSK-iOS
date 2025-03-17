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
     Perform the cleanup e.g. clear dynamic entities, close audio session & VA controller
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

class VAManagerImpl: NSObject, VAManager, NUSASessionDelegate {
    static let shared: VAManager = VAManagerImpl(intentManager: IntentManagerImpl.shared)
    let intentManager: IntentManager
    var orderMedicationEventDetail: EventDetail?
    var createTaskEventDetail: EventDetail?
    var promptForEntityIntentPending: EventDetail?
    weak var delegate: VADelegate?
    
    private init(intentManager: IntentManager) {
        self.intentManager = intentManager
        orderMedicationEventDetail = nil
        createTaskEventDetail = nil
    }
    
    func initialize() {
        initializeSession()
    }
    
    func cleanUp() {
        cleanUpEntities()
        cleanUpSession()
        closeVA()
    }
    
    func sendText(_ text: String) {
        Logger.log("Sending text: \(text)")
        NUSAVirtualAssistantControllerV2.sharedController().sendText(text)
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
        NUSAVirtualAssistantControllerV2.sharedController().delegate = self
        PermissionUtil.requestMicrophonePermissionAndExecute {
            NUSAVirtualAssistantControllerV2.sharedController().openVA(Setting.MODEL_ID.value, options: [
                Constants.OPEN_VA_OPTIONS_SERVER_NAME : Constants.OPEN_VA_OPTIONS_SERVER_URL as NSObject,
                Constants.OPEN_VA_OPTIONS_AUTO_RECONNECT : [
                    Constants.AUTO_RECONNECT_OPTIONS_APP_FOREGROUND : true,
                    Constants.AUTO_RECONNECT_OPTIONS_SERVER_REACHABLE : true
                ] as NSObject
            ])
        }
    }
    
    private func cleanUpEntities() {
        NUSAVirtualAssistantControllerV2.sharedController().clearAllUploadedEntityValues()
    }
    
    private func cleanUpSession() {
        NUSASession.shared().delegate = nil
        NUSASession.shared().close()
    }
        
    private func closeVA() {
        NUSAVirtualAssistantControllerV2.sharedController().delegate = nil
        NUSAVirtualAssistantControllerV2.sharedController().closeVA()
    }
    
    internal func vaDelegate(_ delegate: VADelegate) {
        self.delegate = delegate
    }
    
}

extension VAManagerImpl: NUSAVirtualAssistantControllerV2Delegate 
{
    
    private func handleEventDetail(_ eventDetail: EventDetail?) {
        if let intent = eventDetail?.nluResult.intent {
            if(intent == Constants.INTENT_ORDER_MEDICATION) {
                handleOrderMedication(eventDetail)
            } else if (intent == Constants.INTENT_PROMPT_CHOICE) {
                handlePromptForChoice(eventDetail)
            } else if (intent == Constants.INTENT_REMINDERS) {
                handleCreateTask(eventDetail)
            } else if (intent == Constants.INTENT_PROMPT_FREE_TEXT) {
                handlePromptForFreeText(eventDetail)
            } else if (intent == Constants.INTENT_OTHERS_CALL || intent == Constants.INTENT_SEND_MESSAGE) {
                handlePromptForEntityWorkflow(eventDetail: eventDetail)
            } else if (intent == Constants.INTENT_ENTITIES_RESULT) {
                handlePromptForEntityWorkflowResponse(eventDetail: eventDetail)
            } else {
                intentManager.intentUpdate(eventDetail)
            }
        }
    }
        
    private func handlePromptForEntityWorkflow(eventDetail: EventDetail?) {
        let receipient = EntitiesUtil.getEntityValue(entityName: Constants.DYNAMIC_ENTITIES_RECIPIENT_NAME, eventDetail?.nluResult)
        if receipient.count > 0 {
            promptForEntityIntentPending = nil
            intentManager.intentUpdate(eventDetail)
        } else {
            promptForEntityIntentPending = eventDetail
            startPromptForEntityWorkflow(eventDetail: eventDetail)
        }
    }

    private func handlePromptForEntityWorkflowResponse(eventDetail: EventDetail?) {
        let receipient = EntitiesUtil.getEntityValue(entityName: Constants.DYNAMIC_ENTITIES_RECIPIENT_NAME, eventDetail?.nluResult)
        if receipient.count > 0 {
            EntitiesUtil.setEntity(value: receipient,
                                   entityName: Constants.DYNAMIC_ENTITIES_RECIPIENT_NAME,
                                   nluResult: promptForEntityIntentPending?.nluResult)
            intentManager.intentUpdate(promptForEntityIntentPending)
            promptForEntityIntentPending = nil
        } else {
            promptForEntityIntentPending = eventDetail
            startPromptForEntityWorkflow(eventDetail: eventDetail)
        }
    }

    private func startPromptForEntityWorkflow(eventDetail: EventDetail?) {
        NUSAVirtualAssistantControllerV2.sharedController().prompt(forEntities: [Constants.DYNAMIC_ENTITIES_RECIPIENT_NAME],
                                                                   withPrompt: Constants.TEXT_SPECIFY_RECIPIENT,
                                                                   allowNewIntent: true)
    }
    
    private func handleOrderMedication(_ eventDetail: EventDetail?) {
        orderMedicationEventDetail = eventDetail;
        NUSAVirtualAssistantControllerV2.sharedController().prompt(forChoice: Constants.PROMPT_CHOICE_STRING, withPrompt: Constants.PROMPT_CHOICE_TTS)
    }
    
    private func handlePromptForChoice(_ eventDetail: EventDetail?) {
        if(eventDetail?.nluResult.entityStringValue == Constants.PROMPT_CHOICE_COMPLETE) {
            intentManager.intentUpdate(orderMedicationEventDetail)
            orderMedicationEventDetail = nil;
        }
    }
    
    private func handleCreateTask(_ eventDetail: EventDetail?) {
        if(EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_TASK_DESCRIPTION, eventDetail?.nluResult) == "") {
            createTaskEventDetail = eventDetail
            processPromptForFreeText()
        } else {
            intentManager.intentUpdate(eventDetail)
        }
    }
    
    private func handlePromptForFreeText(_ eventDetail: EventDetail?) {
        let value = EntitiesUtil.getEntityValue(entityName: EntitiesUtil.ENTITY_FREE_TEXT, eventDetail?.nluResult)
        if(value != "") {
            EntitiesUtil.setEntity(value: value,
                                   entityName: EntitiesUtil.ENTITY_TASK_DESCRIPTION,
                                   nluResult: createTaskEventDetail?.nluResult)
            intentManager.intentUpdate(createTaskEventDetail)
            createTaskEventDetail=nil
        }
    }
    
    private func processPromptForFreeText() {
        NUSAVirtualAssistantControllerV2.sharedController().prompt(forFreeText: Constants.PROMPT_FREE_TEXT_TTS);
    }
    
    private func processResultString(_ result: String!) {
        if let jsonData = result.data(using: .utf8 ) {
            let eventDetail = try? JSONDecoder().decode(EventDetail.self, from: jsonData)
            handleEventDetail(eventDetail)
        }
    }
    
    private func uploadDynamicEntities() {
        for dynamicEntity in DynamicEntity.DYNAMIC_ENTITIES {
            if !dynamicEntity.uploaded {
                let errorCode = NUSAVirtualAssistantControllerV2.sharedController().uploadEntityValues( dynamicEntity.name, entityValues: dynamicEntity.jsonString, withCompletionHandler: { (error) in
                    if let error = error {
                        Logger.log("\nError uploading dynamic entity: \(dynamicEntity.name), error: \(error.localizedDescription)")
                    } else {
                        Logger.log("\nDynamic entity successfully uploaded: \(dynamicEntity.name)")
                    }
                })
                
                Logger.log("\nTrying to upload dynamic entity \(dynamicEntity.name): \(errorCode)")
                dynamicEntity.uploaded = (errorCode == VAResultCodeSuccess)
            }
        }
    }
    
    func nluResult(_ result: String!, errorCode: NUSAVirtualAssistantErrorCode, message: String!) {
        Logger.log("NLU Result: \(result ?? "EMPTY")")
        processNluResult(result)
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
    
    // Gives the virtual assistant state description
    private func getStateDescription(_ state: VAState) -> String {
        var stateName: String
        switch state {
        case VAStateOpened:
            stateName = Constants.STATE_OPEN
        case VAStateClosed:
            stateName = Constants.STATE_CLOSE
        default:
            stateName = Constants.STATE_UNKNOWN
        }
        return stateName
    }

    
    
    // Gives the virtual assistant error description
    private func getErrorDescription(_ errorCode: VAResultCode) -> String {
        var errorDescription: String
        switch errorCode {
        case VAResultCodeSuccess:
            errorDescription = Constants.NO_ERROR
        case VAResultCodeBadRequestError:
            errorDescription = Constants.CONFIGURATION_ERROR
        case VAResultCodeNetworkError:
            errorDescription = Constants.NETWORK_ERROR
        case VAResultCodeInternalServerError:
            errorDescription = Constants.SERVER_ERROR
        case VAResultCodeApplicationStateError:
            errorDescription = Constants.APPLICATION_STATE_ERROR
        case VAResultCodeInternalSDKError:
            errorDescription = Constants.PARAMETER_ERROR
        case VAResultCodeAutoReconnecting:
            errorDescription = Constants.AUTO_RECONNECTING_ERROR
        default:
            errorDescription = Constants.MISSING_ERROR
        }
        return errorDescription
    }
    
    func vaSessionStateChanged(_ state: VAState, resultCode: VAResultCode, message: String?) {
        if resultCode == VAResultCodeSuccess &&  state == VAStateOpened {
            
            Logger.log("\(message ?? Constants.STATE_CHANGE_SUCCESS)\n")

            // Upload dynamic entities when VA is successfully initialized
            uploadDynamicEntities()
            self.delegate?.onVAInitializationSucceeded()
        } else {
            let stateString = getStateDescription(state)
            let errorString = getErrorDescription(resultCode)
            Logger.log("Event : State Changed \nError : \(errorString)\nMessage : \(message ?? "EMPTY")\nState : \(stateString)\n")
            DispatchQueue.main.async {
                self.delegate?.onVAInitializationFailed(withError: errorString, message: (message ?? "EMPTY"))
            }
        }
    }
    
    func vaEventGenerated(_ event: VAEvent) {
        print("This is an event \(event.eventType) : \(event)")
        Logger.log("\nEvent generated:\nEvent type:\(event.eventType)\nDetail: \(event.details ?? "")\n")
        switch event.eventType {
        case VAEventTypeInactive:
            break
        case VAEventTypeActive:
            break
        case VAEventTypeProcessing:
            break
        case VAEventTypeComplete:
            processResultString(event.details)
            submitPartnerFeedback(event.details)
            break
        case VAEventTypeCanceled:
            handleCancelEvent()
            submitPartnerFeedback(event.details)
            break
        case VAEventTypeBadRequest:
            break
        default:
            break
        }
    }
    
    private func submitPartnerFeedback(_ event: String!) {
        if let jsonData = event.data(using: .utf8 ) {
            
            var intentName = Constants.DEFAULT_NOT_PROVIDED
            var nluId = Constants.DEFAULT_NOT_PROVIDED
            var feedbackType : VAFeedbackType
            var feedbackInfo : String
            
            do {
                let eventDetail = try JSONSerialization.jsonObject(with: jsonData, options:[]) as! NSDictionary
                let resultCode = ((eventDetail.value(forKey: "status") as! NSDictionary).value(forKey: "resultCode") as! String)
                
                if resultCode != "NO_ERROR" {
                    feedbackType = VAFeedbackTypeProcessingError
                    let message = ((eventDetail.value(forKey: "status") as! NSDictionary).value(forKey: "message") as! String)
                    feedbackInfo = "Received ProcessingError during NLU transaction/error with message - \(message)"
                } else {
                    nluId = ((eventDetail.value(forKey: "nluResult") as! NSDictionary).value(forKey: "nluId") as! String)
                    intentName = getIntentName(eventDetail)
                    
                    if intentName == "NO_MATCH" ||
                        intentName == "NO_INTENT" {
                        feedbackType = VAFeedbackTypeUnsupported
                        feedbackInfo = "\(intentName) intent is unsupported in EHR application."
                    } else {
                        feedbackType = VAFeedbackTypeSupported
                        feedbackInfo = "Received the expected intent \(intentName)."
                    }
                }
            } catch _ as NSError {
                feedbackType = VAFeedbackTypeProcessingError;
                feedbackInfo = "Received ProcessingError during NLU transaction.";
            }
            
            let errorCode = NUSAVirtualAssistantControllerV2.sharedController().partnerFeedback(feedbackType, intentName: intentName, nluId: nluId, feedbackInfo: feedbackInfo, withCompletionHandler: { (error) in
                if let error = error {
                    Logger.log("\n Submitting partner feedback, Error Decription:\(error)")
                } else {
                    Logger.log("\n Successfully submitted partner feedback")
                }
            })
            
            Logger.log("\n** Partner Feedback sent with feedbackType: \(feedbackType), intentName: \(intentName), nluId: \(nluId), feedbackInfo: \(feedbackInfo) Returned error code \(errorCode)")
        }
    }
    
    private func getIntentName(_ eventDetail: NSDictionary!) -> String {
        var intentName = Constants.DEFAULT_NOT_PROVIDED
        if let nluResult = eventDetail["nluResult"] as? [String:Any] {
            if let interpretations = nluResult["interpretations"] as? NSArray {
                if let array = interpretations[0] as? [String:Any] {
                    if let multi = array["multiIntentInterpretation"] as? [String:Any] {
                        if let root = multi["root"] as? [String:Any] {
                            if let intent = root["intent"] as? [String:Any] {
                                if let name = intent["name"] as? String {
                                    intentName = name
                                }
                            }
                        }
                    }
                }
            }
        }
        return intentName;
    }
    
    
    private func handleCancelEvent() {
        promptForEntityIntentPending = nil
    }
}
