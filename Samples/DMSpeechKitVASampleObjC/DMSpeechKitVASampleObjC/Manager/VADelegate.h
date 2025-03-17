//
//  VAManager.h
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2020 Nuance Communications Inc. All rights reserved.
//

@protocol VADelegate <NSObject>

/*!
 @brief Method called when VA is successfully initialized
 */
- (void)onVAInitializationSucceeded;

@end
