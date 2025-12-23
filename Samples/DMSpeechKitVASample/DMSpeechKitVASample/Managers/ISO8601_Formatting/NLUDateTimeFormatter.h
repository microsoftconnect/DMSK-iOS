//
//  NLUDateTimeFormatter.h
//  Class to convert DMVA type NLU JSON for date/time to ISO8601 format
//
//  Copyright © 2020 Nuance Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLUDateTimeFormatter : NSObject

- (instancetype)init:(NSInteger) defaultHour
       defaultMinute:(NSInteger) defaultMinute
       defaultSecond:(NSInteger) defaultSecond
currentTimeAsDefaultValue:(BOOL) currentTimeAsDefaultValue
 showTimeInDateValue:(BOOL) showTimeInDateValue;

- (NSString *)getISO8601FormatFromJSONString:(NSString *)jsonString
                                    timeZone:(NSTimeZone *)timeZone;

@end
