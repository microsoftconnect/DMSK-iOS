//
//  IntentManager.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import "IntentManager.h"
#import "Constants.h"
#import "Logger.h"
#import <DragonMedicalSpeechKit/DragonMedicalSpeechKit.h>
#import <DragonMedicalSpeechKit/UIView+NUSAEnabled.h>

@implementation IntentManager

+ (instancetype)sharedInstance {
    static IntentManager *sharedIntentManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIntentManager = [[self alloc] init];
    });
    return sharedIntentManager;
}

- (void)handleIntent:(NSDictionary *)dialogDictionary {
    IntentType intentType = [self getIntentTypeFromDictionary:dialogDictionary];
    switch (intentType) {
        case IntentTypeHelp:
            LOG(@":::Show help:::");
            break;
        case IntentTypeOrderMedication:
            LOG(@":::Order Medication:::");
            break;
        case IntentTypeSendMessage:
            LOG(@":::Send Message:::");
            break;
        case IntentTypeReminders:
            LOG(@":::Reminders:::");
            break;
        case IntentTypeDocumentSection:
            [self enableDictation];
            LOG(@":::Document Note:::");
            break;
        case IntentTypeShowNote:
            LOG(@":::Show Note:::");
            break;
        case IntentTypeOthers:
            LOG(@":::Others:::");
            break;
        default:
            LOG(@":::Default:::");
            break;
    }
}

#pragma mark -
#pragma mark Other utility methods
- (IntentType)getIntentTypeFromDictionary:(NSDictionary *)dialogDictionary {
    NSArray *taskArray = [dialogDictionary objectForKey:DIALOG_RESPONSE_KEY_TASKS];
    NSString *intentString = DMVA_INTENT_OTHERS;
    
    if ([taskArray count]) {
        NSDictionary* taskDict = [taskArray firstObject];
        if([taskDict count]) {
            if ([[taskDict objectForKey:DIALOG_RESPONSE_KEY_STATE] isEqualToString:DIALOG_RESPONSE_STATE_FINISHED])
                intentString = [taskDict valueForKey:DIALOG_RESPONSE_KEY_INTENT];
        }
    }
    
    IntentType intentType;
    if ([intentString isEqualToString:DMVA_INTENT_SHOW_HELP]) {
        intentType = IntentTypeHelp;
    } else if ([intentString isEqualToString:DMVA_INTENT_ORDER_MEDICATION]) {
        intentType = IntentTypeOrderMedication;
    } else if ([intentString isEqualToString:DMVA_INTENT_REMINDERS]) {
        intentType = IntentTypeReminders;
    } else if ([intentString isEqualToString:DMVA_INTENT_SEND_MESSAGE]) {
        intentType = IntentTypeSendMessage;
    } else if ([intentString isEqualToString:DMVA_INTENT_DOCUMENT_SCETION]) {
        intentType = IntentTypeDocumentSection;
    } else if ([intentString isEqualToString:DMVA_INTENT_SHOW_NOTE]) {
        intentType = IntentTypeShowNote;
    } else {
        intentType = IntentTypeOthers;
    }
    return intentType;
}

#pragma mark -
#pragma mark Other utility methods
-(void) enableDictation {
    if (_delegate != NULL && [_delegate respondsToSelector:@selector(focusDictation)]) {
        [_delegate focusDictation];
        NSError *error=nil;
        bool result = [[NUSASession sharedSession] startRecording:&error];
        if(!result){
            NSLog(@"StartRecording error : %@", [error localizedDescription]);
        }
    }
}

@end
