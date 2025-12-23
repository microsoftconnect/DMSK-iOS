//
//  VAManager.h
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019 Nuance Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DragonMedicalSpeechKit/DragonMedicalSpeechKit.h>
#import "VADelegate.h"

/*!
 @brief Class to handle the VA functionality in the application
 */
@interface VAManager : NSObject <NUSAVirtualAssistantControllerDelegate>

/*!
 @brief Singleton instance of VAManager
 */
+ (instancetype)sharedInstance;

/*!
 @brief Use this method to initialize the Audio session at the launch of the Application
 */
- (void)initializeSession;

/*!
 @brief Initialize the Virtual Assistant grammar model after the VuiController has been initialized
 */
- (void)initializeVAController;

/*!
 @brief Closes the audio session and VA controller
 */
- (void)cleanUp;

/*!
 @brief Sends the dialog text to the DMVA to start or continue the dialog
 @param text The text to send to the DMVA for processing
 */
- (void)sendText:(NSString *)text;

/*!
 @brief Property used to call methods of VADelegate
 */
@property (nonatomic, weak) id <VADelegate> vaDelegate;

@end
