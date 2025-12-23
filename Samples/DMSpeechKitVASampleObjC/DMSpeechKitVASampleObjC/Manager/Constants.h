//
//  Constants.h
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//


#define PARTNER_GUID        @"ENTER_YOUR_PARTNER_GUID"
#define ORG_TOKEN           @"ENTER_YOUR_ORGANIZATION_TOKEN"
#define DEFAULT_APP_NAME    @"DMVA Sample App"
#define DEFAULT_MODEL_ID    @"PhysicianVirtualAssistant_dmva_200"

// Login
#define MAIN_STORY_BOARD @"Main"
#define HOMESCREEN_NAV_CONTROLLER @"HomeNavController"
#define USERDEFAULTS_USERNAME_KEY @"username"

// JSON response keys
#define DIALOG_RESPONSE_KEY_TASKS                   @"tasks"
#define DIALOG_RESPONSE_KEY_STATE                   @"state"
#define DIALOG_RESPONSE_KEY_INTENT                  @"intent"
#define DIALOG_RESPONSE_STRING_TTS                  @"tts"
#define DIALOG_RESPONSE_STRING_FACETS_NAME_PATH     @"actions.facets.name"
#define DIALOG_RESPONSE_STRING_FACETS_VALUE_PATH    @"actions.facets.value"

// Dialog state keys
#define DIALOG_RESPONSE_STATE_FINISHED  @"finished"
#define DIALOG_RESPONSE_STATE_ABORTED   @"aborted"

// JSON response for Log Dialog result
#define DIALOG_RESPONSE_LOG             @"LOG"

// Localized strings
#define DIALOG_ABORTED_MESSAGE          LOCALIZE_STRING(@"Message_Aborted")

// Macro to localize strings
#define LOCALIZE_STRING(key)            NSLocalizedString(key, @"")

// Supported Intents
#define DMVA_INTENT_SHOW_HELP           @"dmvaHelp"
#define DMVA_INTENT_ORDER_MEDICATION    @"dmvaOrderMedication"
#define DMVA_INTENT_OTHERS              @"dmvaShowLabClassResults"
#define DMVA_INTENT_REMINDERS           @"dmvaCreateTask"
#define DMVA_INTENT_SEND_MESSAGE        @"dmvaSendMessage"
#define DMVA_INTENT_DOCUMENT_SCETION    @"dmvaDocumentSection"
#define DMVA_INTENT_SHOW_NOTE           @"dmvaShowItem"

// Dynamic Concepts
#define DYNAMIC_CONCEPT_ITEMS_NAME      @"SHOW_ITEM_DYNAMIC"
#define DYNAMIC_CONCEPT_ITEMS_JSON      @"[{\"literal\":\"settings\",\"value\":\"show_settings\"},{\"literal\":\"settings screen\",\"value\":\"show_settings\"},{\"literal\":\"logs\",\"value\":\"show_logs\"},{\"literal\":\"logs screen\",\"value\":\"show_logs\"},{\"literal\":\"home\",\"value\":\"show_home\"},{\"literal\":\"home screen\",\"value\":\"show_home\"},{\"literal\":\"notes\",\"value\":\"show_notes\"},{\"literal\":\"notes screen\",\"value\":\"show_notes\"}]"

#define DYNAMIC_CONCEPT_RECIPIENT_NAME  @"RECIPIENT_DYNAMIC"
#define DYNAMIC_CONCEPT_RECIPIENT_JSON  @"[{\"literal\":\"Alice\",\"value\":\"Alice Walker\"},{\"literal\":\"Bob\",\"value\":\"Bob Marley\"},{\"literal\":\"Susan\",\"value\":\"Susan Walker\"},{\"literal\":\"David\",\"value\":\"David Walker\"},{\"literal\":\"Sarah\",\"value\":\"Sarah Walker\"},{\"literal\":\"John\",\"value\":\"John Grisham\"},{\"literal\":\"Dragon\",\"value\":\"Nuance Dragon Medical\"}]"

#define DYNAMIC_CONCEPTS_NOTES_NAME     @"NOTE_SECTION_DYNAMIC"
#define DYNAMIC_CONCEPTS_NOTES_JSON     @"[{\"literal\":\"exam\",\"value\":\"exam_notes\"},{\"literal\":\"physician\",\"value\":\"physician_notes\"}]"
