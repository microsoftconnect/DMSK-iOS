//
//  Logger.h
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOG(stream) [Logger log:stream]
#define LOG_PARAM(stream, param) [Logger log:[NSString stringWithFormat:stream, param]]

/*!
 @brief Protocol to notify the listening class that new data is added to the log buffer
 */
@protocol LoggerDelegate
/*!
 @brief Called when new data is added to the log buffer
 */
-(void)loggerBufferUpdated;

@end

/*!
 @brief Utility class to log data on console hold it for on-screen logging
 */
@interface Logger : NSObject

/*!
 @brief Initialize the logger with delegate which listens to logger updates
 @param delegate Object that listens to the updates
 */
+ (void)initLogger:(id<LoggerDelegate>)delegate;

/*!
 @brief To get the current state of the logger buffer
 */
+ (NSMutableString*)getLoggerDump;

/*!
 @brief To reset the logger buffer to empty
 */
+ (void)resetLoggerDump;

/*!
 @brief To append more data to the logger buffer
 */
+ (void)log:(NSString*)logString;

@end
