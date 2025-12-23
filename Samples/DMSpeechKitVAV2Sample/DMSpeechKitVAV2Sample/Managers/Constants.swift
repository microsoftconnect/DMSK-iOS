//
//  Constants.swift
//  DMSpeechKitVASample
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

import Foundation

class Constants {

    // Application configuration
    static let DEFAULT_APP_NAME = "DMVA Sample App"
    static let DEFAULT_PARTNER_GUID = "ENTER_YOUR_PARTNER_GUID"
    static let DEFAULT_ORG_TOKEN = "ENTER_YOUR_ORGANIZATION_TOKEN"
    static let DEFAULT_MODEL_ID = "PhysicianVirtualAssistant_dmva_210"
    static let DEFAULT_APP_VERSION = "1.0"
    
    // Screen titles e.g. DMVA, Messages, Others, Show me
    static let SCREEN_TITLE_HOME = "dmva".localize()
    static let SCREEN_TITLE_MEDICATION = "medication".localize()
    static let SCREEN_TITLE_REMINDER = "reminders".localize()
    static let SCREEN_TITLE_MESSAGES = "messages".localize()
    static let SCREEN_TITLE_OTHER = "others".localize()
    static let SCREEN_TITLE_SHOWME = "show_me".localize()
    static let SCREEN_TITLE_NOTES = "notes".localize()
    static let SCREEN_TITLE_HELP = "help".localize()
    static let SCREEN_TITLE_SETTING = "settings".localize()

    // Settings
    static let SETTINGS_APP_NAME = "settings_app_name".localize()
    static let SETTINGS_MODEL_ID = "settings_model_id".localize()
    static let SETTINGS_VERSION = "settings_version".localize()
    
    // Login
    static let MAIN_STORY_BOARD = "Main"
    static let HOMESCREEN_NAV_CONTROLLER = "HomeNavController"
    static let USERDEFAULTS_USERNAME_KEY = "username"
    
    // VA Error Codes Description
    static let NO_ERROR = "va_error_no_error".localize()
    static let CONFIGURATION_ERROR = "va_error_config_error".localize()
    static let NETWORK_ERROR = "va_error_network_error".localize()
    static let SERVER_ERROR = "va_error_server_error".localize()
    static let APPLICATION_STATE_ERROR = "va_error_app_error".localize()
    static let PARAMETER_ERROR = "va_error_parameter_error".localize()
    static let UNKNOWN_ERROR = "va_error_unknown_error".localize()
    static let MISSING_ERROR = "va_error_missing_val_error".localize()
    static let AUTO_RECONNECTING_ERROR = "va_error_auto_reconnecting_error".localize()
    
    // VA Event Success Messages
    static let STATE_CHANGE_SUCCESS = "dmva_state_open_success".localize()
    
    // VA States Strings
    static let STATE_OPEN = "NUSAVirtualAssistantStateOpened"
    static let STATE_CLOSE = "NUSAVirtualAssistantStateClosed"
    static let STATE_UNKNOWN = "dmva_state_unknown".localize()
    static let TEXT_SPECIFY_RECIPIENT = "Please specify the receipient".localize()
    
    //Supported Intents
    static let INTENT_ORDER_MEDICATION = "dmvaOrderMedication"
    static let INTENT_SHOW_HELP = "dmvaHelp"
    static let INTENT_REMINDERS = "dmvaCreateTask"
    static let INTENT_SEND_MESSAGE = "dmvaSendMessage"
    static let INTENT_SHOW_ITEM = "dmvaShowItem"
    static let INTENT_DOCUMENT_NOTES = "dmvaDocumentSection"
    
    //PromptForX Intent
    static let INTENT_PROMPT_CHOICE     = "CHOICE_RESULT"
    static let INTENT_PROMPT_FREE_TEXT  = "FREE_TEXT_RESULT"
    
    //'Show me' Intents
    static let INTENT_SHOW_LAB_CLASS_RESULTS            = "dmvaShowLabClassResults"
    static let INTENT_SHOW_RESULTS                      = "dmvaShowResults"
    static let INTENT_SHOW_MEDICATION_RESULTS           = "dmvaShowMedicationResults"
    static let INTENT_SHOW_MEDICATION_CLASS_RESULTS     = "dmvaShowMedicationClassResults"
    static let INTENT_SHOW_MEDICATION_TIME              = "dmvaShowMedicationTime"
    static let INTENT_SHOW_MEDICATION_CLASS_TIME        = "dmvaShowMedicationClassTime"
    static let INTENT_SHOW_PATIENT_ALLERGIES            = "dmvaShowPatientAllergies"
    static let INTENT_SHOW_PATIENT_LAST_VISIT           = "dmvaShowPatientLastVisit"
    static let INTENT_SHOW_PATIENT_VITALS               = "dmvaShowPatientVitals"
    static let INTENT_SHOW_PATIENT                      = "dmvaShowPatient"
    static let INTENT_SHOW_PATIENT_LOCATION             = "dmvaShowPatientLocation"
    static let INTENT_SHOW_SCHEDULE                     = "dmvaShowSchedule"
    
    //'Others' Intents
    static let INTENT_OTHERS_TELL_ME_ITEM               = "dmvaTellItem"
    static let INTENT_OTHERS_CANCEL_CONFIRM             = "dmvaCancelOrConfirm"
    static let INTENT_OTHERS_SCHEDULE_SEARCH            = "dmvaScheduleSearch"
    static let INTENT_OTHERS_CALL                       = "dmvaCall"
    static let INTENT_OTHERS_RETRIEVE_MESSAGE           = "dmvaRetrieveMessages"
    static let INTENT_OTHERS_MEMBER_LOOKUP              = "dmvaMemberLookup"
    static let INTENT_OTHERS_MEMBER_CLOSE               = "dmvaCloseMember"
    static let INTENT_OTHERS_REPEAT_TTS                 = "dmvaRepeatTTS"
    static let INTENT_OTHERS_LIST_SELECTION             = "dmvaListSelection"
    static let INTENT_OTHERS_LIST_NAVIGATION            = "dmvaListNavigation"
    static let INTENT_OTHERS_NOTE                       = "dmvaNote"

    static let INTENT_ENTITIES_RESULT   = "ENTITIES_RESULT"

    //Supported items
    static let ITEM_SHOW_HOME = "show_home"
    static let ITEM_SHOW_LOGS = "show_logs"
    static let ITEM_SHOW_SETTINGS = "show_settings"
    
    //Supported items equivalent to notes
    static let ITEM_SHOW_NOTES = "show_notes"
    static let ITEM_EXAM_NOTES = "exam notes"
    static let ITEM_CARDIOLOGY_NOTES = "cardiology"
    static let ITEM_DISCHARGE_NOTES = "discharge"
    static let ITEM_PHYSICIAN_NOTES = "physician notes"
    static let ITEM_PROGRESS_NOTES = "progress notes"
    static let ITEM_ADMISSION_NOTES = "admission notes"

    static let RESPONSE_STRING_STATE_FINISHED   = "finished"
    static let RESPONSE_STRING_STATE_ABORTED    = "aborted"
    
    //Partner feedback value
    static let DEFAULT_NOT_PROVIDED = "Not Provided"
    
    static let DIALOG_ABORTED_MESSAGE = "dialog_aborted".localize()
    static let ORDER_COMPLETE_MESSAGE = "order_complete".localize()
    static let UNIT_DEFAULT = "unit"
    static let UNIT_REFILLS = " refills"
    
    // HelpViewController constants
    static let HELP_FILE_NAME = "help"
    static let HELP_FILE_EXT = "html"
    
    // HomeViewController constants
    static let SEGUE_ID_SETTINGS = "show_setting"
    static let SEGUE_ID_HELP = "show_help"
    static let SEGUE_ID_NOTES = "show_notes"
    static let SEGUE_ID_DICTATION = "start_dictation"
    static let CELL_ID_MEDICATION = "medication"
    static let CELL_ID_REMINDER = "reminder"
    static let CELL_ID_MESSAGE = "message"
    static let CELL_ID_OTHER = "others"
    static let CELL_ID_HOME = "home"
    static let TIME_INTERVAL = 2.5
    
    // Prompt For Choice
    static let PROMPT_CHOICE_STRING = """
        [
        { \"literal\": \"complete\", \"canonical\": \"complete\"},
        { \"literal\": \"complete it\", \"canonical\": \"complete\"},
        { \"literal\": \"complete order\", \"canonical\": \"complete\"},
        { \"literal\": \"complete the order\", \"canonical\": \"complete\"},

        { \"literal\": \"cancel\", \"canonical\": \"cancel\"},
        { \"literal\": \"cancel it\", \"canonical\": \"cancel\"},
        { \"literal\": \"cancel order\", \"canonical\": \"cancel\"},
        { \"literal\": \"cancel the order\", \"canonical\": \"cancel\"}
        ]
        """
    
    static let PROMPT_CHOICE_COMPLETE           = "complete"
    
    static let PROMPT_CHOICE_TTS = "Would you like to complete the order or cancel it?"
    static let PROMPT_FREE_TEXT_TTS = "What do you want me to remind for?"

    // Dynamic entities
    static let DYNAMIC_ENTITIES_ITEMS_NAME = "SHOW_ITEM_DYNAMIC"
    static let DYNAMIC_ENTITIES_ITEMS_JSON = """
        [
        {"literal":"settings","canonical":"show_settings"},
        {"literal":"settings screen","canonical":"show_settings"},
        {"literal":"logs","canonical":"show_logs"},
        {"literal":"logs screen","canonical":"show_logs"},
        {"literal":"home","canonical":"show_home"},
        {"literal":"home screen","canonical":"show_home"},
        {"literal":"notes","canonical":"show_notes"},
        {"literal":"notes screen","canonical":"show_notes"}
        ]
        """

    static let DYNAMIC_ENTITIES_RECIPIENT_NAME = "RECIPIENT_DYNAMIC"
    static let DYNAMIC_ENTITIES_RECIPIENT_JSON = """
        [
        {"literal":"Alice","canonical":"Alice Walker"},
        {"literal":"Bob","canonical":"Bob Marley"},
        {"literal":"Susan","canonical":"Susan Walker"},
        {"literal":"David","canonical":"David Walker"},
        {"literal":"Sarah","canonical":"Sarah Walker"},
        {"literal":"John","canonical":"John Grisham"},
        {"literal":"Bob Smith","canonical":"Robert Smith"},
        {"literal":"Rob Smith","canonical":"Robert Smith"},
        {"literal":"Robert Smith","canonical":"Robert Smith"},
        {"literal":"Smith","canonical":"Robert Smith"},
        {"literal":"Dragon","canonical":"Nuance Dragon Medical"}
        ]
        """

    static let DYNAMIC_ENTITIES_NOTES_NAME = "NOTE_SECTION_DYNAMIC"
    static let DYNAMIC_ENTITIES_NOTES_JSON = """
        [
        {"literal":"exam","canonical":"exam_notes"},
        {"literal":"assessment","canonical":"assessment"},
        {"literal":"physician","canonical":"physician_notes"}
        ]
        """
    
    static let OPEN_VA_OPTIONS_SERVER_NAME = "SetDMVAServer"
    static let OPEN_VA_OPTIONS_SERVER_URL = "wss://dmvaserver-qa.nuancehce.com/ws"
    
    static let OPEN_VA_OPTIONS_AUTO_RECONNECT = "AutoReconnectOptions"
    static let AUTO_RECONNECT_OPTIONS_APP_FOREGROUND = "AutoReconnectOnAppForeground"
    static let AUTO_RECONNECT_OPTIONS_SERVER_REACHABLE = "AutoReconnectOnServerReachable"
}
