//
//  IntentManager.h
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IntentTypeHelp,
    IntentTypeOrderMedication,
    IntentTypeSendMessage,
    IntentTypeReminders,
    IntentTypeDocumentSection,
    IntentTypeShowNote,
    IntentTypeOthers
}IntentType;

/*!
 @brief Protocol to be implemented by a class that wants to receive the result after Intents has been identified from the dialog response
 */
@protocol IntentDelegate <NSObject>

/*!
 @brief Additional steps required to start recording for dictation on dialog result
 */
- (void)focusDictation;
@end

/*!
 @brief To handle the response of a completed dialog
 */
@interface IntentManager : NSObject

/*!
 @brief Singleton instance of Intent Manager
 */
+ (instancetype)sharedInstance;

/*!
 @brief Handles the response of a completed dialog
 @param dialog Takes the dialog response dictionary as parameter
 */
- (void)handleIntent:(NSDictionary *)dialog;

/*!
 @brief Instance of the class implementing IntentDelegate
 */
@property (nonatomic, weak) id <IntentDelegate> delegate;

@end

