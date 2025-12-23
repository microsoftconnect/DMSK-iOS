//
//  VAManager.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import "VAManager.h"
#import "Constants.h"
#import "IntentManager.h"
#import "Logger.h"
#import <AVFoundation/AVFoundation.h>

@implementation VAManager

typedef enum {
    DialogStateComplete,
    DialogStateIncomplete,
    DialogStateInvalid
}DialogState;


+ (instancetype)sharedInstance {
    static VAManager *sharedVAManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVAManager = [[self alloc] init];
    });
    return sharedVAManager;
}

- (void)initializeSession {
    // Initialize session, to be called as soon as the application launches
    [[NUSASession sharedSession] openForApplication:DEFAULT_APP_NAME
                                        partnerGuid:PARTNER_GUID
                                        licenseGuid:ORG_TOKEN
                                             userId:[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_USERNAME_KEY]];
}

- (void)initializeVAController {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // Set delegate and open model when the VuiController is initialized
            [[NUSAVirtualAssistantController sharedController] setDelegate:self];
            [[NUSAVirtualAssistantController sharedController] openWithModel:DEFAULT_MODEL_ID
                                                                     options:nil];
        }
    }];
}

- (void)cleanUp {
    [[NUSASession sharedSession] close];
    [[NUSAVirtualAssistantController sharedController] setDelegate:nil];
    [[NUSAVirtualAssistantController sharedController] close];
}

- (void)sendText:(NSString *)text {
    [[NUSAVirtualAssistantController sharedController] sendText:text];
}

#pragma mark -
#pragma mark NUSAVirtualAssistantControllerDelegate
- (void)dialogResult: (NSString*) result errorCode: (NUSAVirtualAssistantErrorCode) errorCode message: (NSString*) message {
    LOG_PARAM(@"DialogResult:Message: %@", message);
    LOG_PARAM(@"DialogResult:Result String: %@", result);
    // result is 'LOG' when VA controller logs various events
    if (result != nil && ![result isEqualToString:DIALOG_RESPONSE_LOG]) {
        [self processJsonString:result];
    }
}

- (void)stateChanged:(NUSAVirtualAssistantState) state errorCode: (NUSAVirtualAssistantErrorCode) errorCode message: (NSString*) message {
    LOG_PARAM(@"StateChanged: %@", message);
    if(state == NUSAVirtualAssistantStateOpened){
        // VA Controller successfully initialized - 'DMVA Opened'
        [self uploadDynamicConcept];
        [self.vaDelegate onVAInitializationSucceeded];
    }
}

- (void)conceptResult:(NUSAVirtualAssistantErrorCode) errorCode message: (NSString*) message {
    // Concept upload result
    LOG_PARAM(@"ConceptResult: %@", message);
}

#pragma mark -
#pragma mark Other methods

/*!
 @brief Converts Text-to-speech and plays it out loud
 @param text The text to be converted to speech
 */
- (void)readText:(NSString *)text {
    LOG_PARAM(@"TTS: %@", text);
    [[NUSASession sharedSession] startSpeaking:text];
}

- (void)uploadDynamicConcept {
    // Dynamic concepts for items, e.g. settings, logs, home screen etc.
    NUSAVirtualAssistantErrorCode errorCode = [[NUSAVirtualAssistantController sharedController]
                                               uploadValuesForConcept:DYNAMIC_CONCEPT_ITEMS_NAME
                                               conceptValues:DYNAMIC_CONCEPT_ITEMS_JSON
                                               withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            [Logger log:[NSString stringWithFormat:@"Error uploading concept: %@, error: %@", DYNAMIC_CONCEPT_ITEMS_NAME, error.localizedDescription]];
        } else {
            [Logger log:[NSString stringWithFormat:@"Successfully uploaded concept: %@", DYNAMIC_CONCEPT_ITEMS_NAME]];
        }
    }];
    NSLog(@"NUSAVirtualAssistantErrorCode %d ", errorCode);
    
    // Dynamic concepts for message recipients, e.g. send a message to 'bob' to bring chips
    NUSAVirtualAssistantErrorCode recipientErrorCode = [[NUSAVirtualAssistantController sharedController]
                                                        uploadValuesForConcept:DYNAMIC_CONCEPT_RECIPIENT_NAME
                                                        conceptValues:DYNAMIC_CONCEPT_RECIPIENT_JSON
                                                        withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            [Logger log:[NSString stringWithFormat:@"Error uploading concept: %@, error: %@", DYNAMIC_CONCEPT_RECIPIENT_NAME, error.localizedDescription]];
        } else {
            [Logger log:[NSString stringWithFormat:@"Successfully uploaded concept: %@", DYNAMIC_CONCEPT_RECIPIENT_NAME]];
        }
    }];
    NSLog(@"NUSAVirtualAssistantErrorCode %d ", recipientErrorCode);
}

- (void)notifyErrorMessageFromTTS:(NSDictionary *) dialogDictionary {
    NSString *ttsText = [self getTTSText:dialogDictionary];
    if([ttsText length] != 0){
        [self readText:ttsText];
    }
}

- (NSString*)getTTSText:(NSDictionary*) dialogDictionary {
    NSDictionary* facetsNameDictionary = [dialogDictionary valueForKeyPath:DIALOG_RESPONSE_STRING_FACETS_NAME_PATH];
    NSInteger facetsNameIndex = 0;
    for(NSDictionary* facetsNameArray in facetsNameDictionary){
        NSInteger ttsIndex = 0;
        for(NSString* tts in facetsNameArray){
            if([tts isEqualToString:DIALOG_RESPONSE_STRING_TTS]){
                NSArray* facetsValueArray = [dialogDictionary valueForKeyPath:DIALOG_RESPONSE_STRING_FACETS_VALUE_PATH];
                return [[facetsValueArray objectAtIndex:facetsNameIndex] objectAtIndex:ttsIndex];
            }
            ttsIndex++;
        }
        facetsNameIndex++;
    }
    return @"";
}

- (void)notifyDialogAborted:(NSString *) intentName {
    NSString *logString = [NSString stringWithFormat:@"%@ for %@", DIALOG_ABORTED_MESSAGE, intentName];
    LOG_PARAM(@"%@", logString);
}

- (void)processJsonString:(NSString *) resultString {
    NSError *error = nil;
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:0
                                                  error:&error];
    if (error) {
        NSLog(@"Error parsing the json string: %@", [error localizedDescription]);
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        DialogState state = [self getDialogState:object];
        NSLog(@"DialogState: %d", state);
        
        switch(state)
        {
            case DialogStateComplete:
                [[IntentManager sharedInstance] handleIntent:object];
                break;
            case DialogStateIncomplete:
                [self notifyErrorMessageFromTTS:object];
                break;
            case DialogStateInvalid:
                [self notifyErrorMessageFromTTS:object];
                break;
            default:
                NSLog(@"Invalid state");
                break;
        }
    } else {
        NSLog(@"Response not in right format");
    }
}

- (DialogState)getDialogState:(NSDictionary *) dialogDictionary {
    if (![[dialogDictionary allKeys] containsObject:DIALOG_RESPONSE_KEY_TASKS]) {
        return DialogStateInvalid;
    }
    NSArray *taskArray = [dialogDictionary objectForKey:DIALOG_RESPONSE_KEY_TASKS];
    if ([taskArray count] == 0) {
        return DialogStateInvalid;
    }
    for(NSDictionary *taskDict in taskArray) {
        NSString *dialogState = [taskDict objectForKey:DIALOG_RESPONSE_KEY_STATE];
        if ([dialogState isEqualToString:DIALOG_RESPONSE_STATE_ABORTED]) {
            NSString *intentName = [taskDict objectForKey:DIALOG_RESPONSE_KEY_INTENT];
            [self notifyDialogAborted:intentName];
        } else if ([dialogState isEqualToString:DIALOG_RESPONSE_STATE_FINISHED]) {
            return DialogStateComplete;
        }
    }
    return DialogStateIncomplete;
}

@end

