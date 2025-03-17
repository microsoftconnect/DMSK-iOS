//
//  Logger.m
//  DMSpeechKitVASampleObjC
//
//  Copyright © 2019. All rights reserved.
//

#import "Logger.h"

@implementation Logger

/*!
 @brief Buffer which holds the data for logger
 */
static NSString* buffer = @"";
static id<LoggerDelegate> delegate = nil;
static NSLock* nsLock = nil;

+ (void)initLogger:(id<LoggerDelegate>)delParam {
    delegate = delParam;
    nsLock = [[NSLock alloc] init];
}

+ (NSString*)getLoggerDump {
    return [NSString stringWithString:buffer];
}

+ (void)resetLoggerDump {
    buffer = @"";
}

+ (void)log:(NSString*)logString {
    NSLog(@"%@", logString);
    
    // Logging asynchrounously to keep the main thread unblocked for other UI events
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [nsLock lock];
        buffer = [NSString stringWithFormat:@"%@\n\n",[buffer stringByAppendingString:logString]];
        [nsLock unlock];
        
        // Delegate method to be called on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (delegate != NULL && [(NSObject *)delegate respondsToSelector:@selector(loggerBufferUpdated)]) {
                [delegate loggerBufferUpdated];
            }
        });
    });
}

@end
