//
//  NLUDateTimeFormatter.m
//  Class to convert DMVA type NLU JSON for date/time to ISO8601 format
//
//  Copyright © 2020 Nuance Communications Inc. All rights reserved.
//

#import "NLUDateTimeFormatter.h"

@interface NSObject (DateTimeFormatHelper)

- (BOOL)conceptValueHasDateProperty;
- (BOOL)conceptValueHasTimeProperty;

- (BOOL)conceptValueHasAbsDateProperty;
- (BOOL)conceptValueHasRelDateProperty;
- (BOOL)conceptValueHasAbsTimeProperty;
- (BOOL)conceptValueHasRelTimeProperty;

- (BOOL)conceptValueHasCalendarProperty;
- (BOOL)conceptValueHasCalendarRangeProperty;
- (BOOL)conceptValueHasCalendarRangeStart;
- (BOOL)conceptValueHasCalendarRangeEnd;

@end

@interface DateTimeFormatterData : NSObject

@property (nonatomic) BOOL isServerDayProvided;

@property (nonatomic) BOOL isServerMonthProvided;
@property (nonatomic) BOOL isServerYearProvided;
@property (nonatomic) BOOL isServerTimeProvided;
@property (nonatomic) BOOL showTimeInDate;

@property (nonatomic) NSInteger serverDay;
@property (nonatomic) NSInteger serverMonth;
@property (nonatomic) NSInteger serverYear;
@property (nonatomic) NSInteger serverHour;
@property (nonatomic) NSInteger serverMinute;
@property (nonatomic) NSInteger serverSecond;
@property (strong, nonatomic) NSString* serverFullDate;
@property (strong, nonatomic) NSString* serverFullTime;
@property (strong, nonatomic) NSDate* serverDateTime;
@property (nonatomic) NSString* stepForDate;
@property (nonatomic) NSInteger incrementForDate;
@property (nonatomic) NSInteger dayOfWeek;
@property (strong, nonatomic) NSString* nameDay;
@property (strong, nonatomic) NSString* modifierForDate;
@property (nonatomic) NSString* stepForTime;
@property (nonatomic) NSInteger incrementForTime;
@property (nonatomic) BOOL isReferenceDateProvided;
@property (nonatomic) BOOL isReferenceTimeProvided;
@property (nonatomic) BOOL isServerDayOfWeekSameAsCurrentDay;

@property (nonatomic) NSInteger convertedDay;
@property (nonatomic) NSInteger convertedMonth;
@property (nonatomic) NSInteger convertedYear;
@property (nonatomic) NSInteger convertedHour;
@property (nonatomic) NSInteger convertedMinute;
@property (nonatomic) NSInteger convertedSecond;
@property (strong, nonatomic) NSString* convertedFullDate;
@property (strong, nonatomic) NSString* convertedFullTime;
@property (strong, nonatomic) NSDate* convertedDateTime;
@property (strong, nonatomic) NSTimeZone *timezoneRequested;

@end

@implementation DateTimeFormatterData

- (DateTimeFormatterData*) init
{
    if(self = [super init]) {
        _isServerDayProvided = NO;
        _isServerMonthProvided = NO;
        _isServerYearProvided = NO;
        _isServerTimeProvided = YES;
        _serverDay = -1;
        _serverMonth = -1;
        _serverYear = -1;
        _serverFullDate = @"-1--1--1";
        _serverHour = -1;
        _serverMinute = 0;
        _serverSecond = 0;
        _serverFullTime =@"00:00:00";
        _stepForDate = @"";
        _incrementForDate = -1;
        _dayOfWeek = -1;
        _nameDay = nil;
        _modifierForDate = nil;
        _stepForTime = @"";
        _isReferenceDateProvided = NO;
        _isReferenceTimeProvided = NO;
        _isServerDayOfWeekSameAsCurrentDay = NO;
    }
    return self;
}

- (NSString*)generateFinalDateInISO8601Format
{
    // Take same current date time that we had stored earlier.
    NSDate *currentDate = _convertedDateTime;  // [NSDate date];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:_timezoneRequested];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:currentDate];
    
    [components setDay:_serverDay];
    [components setMonth:_serverMonth];
    [components setYear:_serverYear];
    
    [components setHour:_serverHour];
    [components setMinute:_serverMinute];
    [components setSecond:_serverSecond];
    NSDate *expectedDate = [calendar dateFromComponents:components];
    _serverDateTime = expectedDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    
    // If Show Time in date enabled and Server provides the time, then only show the TIME
    if (!_showTimeInDate && !_isServerTimeProvided)
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    [dateFormatter setTimeZone:_timezoneRequested];
    
    NSString *iso8601String = [dateFormatter stringFromDate:expectedDate];
    return iso8601String;
}

- (void) parseAbsoluteDate:(NSDictionary *) partialDate
{
    if ([partialDate isKindOfClass: [NSDictionary class]]) {
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        
        if ([partialDate[@"nuance_DAY"] isKindOfClass: [NSNumber class]]) {
            _serverDay = [((NSNumber*)partialDate[@"nuance_DAY"]) unsignedIntegerValue];
            _isServerDayProvided = YES;
        }
        
        if ([partialDate[@"nuance_MONTH"] isKindOfClass: [NSNumber class]]) {
            _serverMonth = [((NSNumber*)partialDate[@"nuance_MONTH"]) intValue];
            _isServerMonthProvided = YES;
        }
        
        if ([partialDate[@"nuance_YEAR"] isKindOfClass: [NSNumber class]]) {
            _serverYear = [((NSNumber*)partialDate[@"nuance_YEAR"]) intValue];
            _isServerYearProvided = YES;
        }
        _serverFullDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)_serverYear, (long)_serverMonth, (long)_serverDay];
    }
}

- (void)parseAbsoluteTime:(NSDictionary *)partialTime
{
    BOOL isAm = YES;
    BOOL AMPM_Provided = NO;
    BOOL IsTodayPartofPhrase = NO;
    
    // Handled special case for *today* where user utters phrase "remind me to [SOME_ACTION e.g. recheck lungs] TODAY 5 o'Clock.
    if (_incrementForDate == 0 && [_stepForDate isEqualToString:@"day"] )
        IsTodayPartofPhrase = YES;
    
    if ([partialTime isKindOfClass: [NSDictionary class]]) {
        if (partialTime[@"nuance_AMPM"]) {
            AMPM_Provided = YES;
            isAm = [partialTime[@"nuance_AMPM"] isEqualToString:@"am"];
        }
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        
        if (partialTime[@"nuance_HOUR"] && [partialTime[@"nuance_HOUR"] isKindOfClass:[NSNumber class]]) {
            NSInteger hourInt = [((NSNumber*)partialTime[@"nuance_HOUR"]) intValue];
            NSInteger minuteInt = [((NSNumber*)partialTime[@"nuance_MINUTE"]) intValue];
            
            //if AM_PM is not provided and date is not part of spken phrase, find AM or PM as per the next occurence of the time uttered.
            if (!AMPM_Provided && (!_isServerDayProvided || IsTodayPartofPhrase))
            {
                //find current time hour value in 0 to 11 range and compare with hour value from JSON
                NSInteger currentHour = (_convertedHour < 12) ? _convertedHour : _convertedHour - 12;
                if ((hourInt == currentHour) && (minuteInt > _convertedMinute))
                    isAm = _convertedHour < 12;
                else if ((hourInt == 12) && (currentHour == 0) && (minuteInt > _convertedMinute))
                    isAm = _convertedHour >= 12;
                else if (hourInt > currentHour)
                    isAm = _convertedHour < 12;
                else
                    isAm = _convertedHour >= 12;
                //Special check for hour spoken as 12. Change the AM to PM or vice versa
                if (hourInt == 12)
                    isAm = !isAm;
            }
            
            if (isAm)
                _serverHour = (hourInt == 12) ? 0 : hourInt;
            else
                _serverHour = (hourInt >= 12) ? hourInt : hourInt + 12;
        }
        
        if (partialTime[@"nuance_MINUTE"] && [partialTime[@"nuance_MINUTE"] isKindOfClass:[NSNumber class]]) {
            _serverMinute = [((NSNumber*)partialTime[@"nuance_MINUTE"]) intValue];
        }
        
        if (partialTime[@"nuance_SECOND"] && [partialTime[@"nuance_SECOND"] isKindOfClass:[NSNumber class]]) {
            _serverSecond = [((NSNumber*)partialTime[@"nuance_SECOND"]) intValue];
        }
        
        _serverFullTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)_serverHour, (long)_serverMinute, (long)_serverSecond];
    }
}

- (void)convertDateTimeToRequestedTimeZone:(NSTimeZone *)timeZone
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setTimeZone:timeZone];
    
    _timezoneRequested = timeZone;
    
    NSString *dateString;
    dateString = [dateFormatter stringFromDate:currentDate];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: timeZone];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:currentDate];
    
    _convertedDay = [components day];
    _convertedMonth = [components month];
    _convertedYear = [components year];
    _convertedHour = [components hour];
    _convertedMinute = [components minute];
    _convertedSecond = [components second];
    
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    dateString = [dateFormatter stringFromDate:currentDate];
    _convertedFullTime = dateString;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormatter stringFromDate:currentDate];
    _convertedFullDate = dateString;
    _convertedDateTime = currentDate;
}


- (void)parseRelativeDate:(NSDictionary *) partialDate
{
    if ([partialDate isKindOfClass: [NSDictionary class]]) {
        if (partialDate[@"nuance_STEP"] != nil) {
            _stepForDate = partialDate[@"nuance_STEP"];
            
            if (partialDate[@"nuance_INCREMENT"] && [partialDate[@"nuance_INCREMENT"] isKindOfClass: [NSNumber class]])
            {
                _incrementForDate = [((NSNumber*)partialDate[@"nuance_INCREMENT"]) intValue];
            }
        }
        else if(partialDate[@"nuance_DAY_OF_WEEK"] != nil && [partialDate[@"nuance_DAY_OF_WEEK"] isKindOfClass: [NSNumber class]]) {
            _dayOfWeek = [(NSNumber*)partialDate[@"nuance_DAY_OF_WEEK"] intValue];
            
            if(partialDate[@"nuance_INCREMENT"] != nil && partialDate[@"nuance_STEP"] == nil )
            {
                _incrementForDate = [((NSNumber*)partialDate[@"nuance_INCREMENT"]) intValue];
                _stepForDate = @"week";
            }
        }
        else if (partialDate[@"nuance_NAMED_DAY"]!= nil) {
            _nameDay = partialDate[@"nuance_NAMED_DAY"];
        }
        
        if (partialDate[@"nuance_MODIFIER"]!= nil) {
            _modifierForDate = partialDate[@"nuance_MODIFIER"];
        }
    }
}

- (void)parseRelativeTime : (NSDictionary *) partialTime
{
    if ([partialTime isKindOfClass: [NSDictionary class]]) {
        if (partialTime[@"nuance_STEP"] != nil) {
            _stepForTime=partialTime[@"nuance_STEP"];
            
            if (partialTime[@"nuance_INCREMENT"] && [partialTime[@"nuance_INCREMENT"] isKindOfClass: [NSNumber class]])
            {
                _incrementForTime = [(NSNumber*)partialTime[@"nuance_INCREMENT"] intValue];
            }
        }
        if (partialTime[@"nuance_MODIFIER"]!= nil) {
            //do nothing
        }
    }
}
@end


@interface NLUDateTimeFormatter()
@property (nonatomic, strong) DateTimeFormatterData *dateTimeFormatterDataObject;
@property (nonatomic, strong) DateTimeFormatterData *dateTimeFormatterRefDataObject;
@property (nonatomic) NSUInteger defaultHour;
@property (nonatomic) NSUInteger defaultMinute;
@property (nonatomic) NSUInteger defaultSecond;
@property (nonatomic) BOOL useCurrentTimeAsDefault;
@property (nonatomic) BOOL showTimeInDate;
@end

@implementation NLUDateTimeFormatter


- (instancetype)init:(NSInteger) defaultHour
      defaultMinute:(NSInteger) defaultMinute
      defaultSecond:(NSInteger) defaultSecond
currentTimeAsDefaultValue:(BOOL) currentTimeAsDefaultValue
showTimeInDateValue:(BOOL) showTimeInDateValue {
    if( self = [super init] ) {
        _defaultHour = defaultHour;
        _defaultMinute = defaultMinute;
        _defaultSecond = defaultSecond;
        _useCurrentTimeAsDefault = currentTimeAsDefaultValue;
        _showTimeInDate = showTimeInDateValue;
    }
    return self;
}

- (NSString *)getISO8601FormatFromJSONString:(NSString *)jsonString timeZone:(NSTimeZone *)timeZone {
    NSString *retVal = NULL;
    if (jsonString != NULL && [jsonString length] > 0) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = NULL;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error == NULL && [jsonObject isKindOfClass:[NSDictionary class]]) {
            retVal = [self getDateTimeInISO8601Format:jsonObject timeZone:timeZone];
        }
    }
    return retVal;
}

- (NSString *)getDateTimeInISO8601Format:(NSDictionary *)conceptDict timeZone:(NSTimeZone *) timeZone
{
    _dateTimeFormatterDataObject = [[DateTimeFormatterData alloc] init];
    [_dateTimeFormatterDataObject convertDateTimeToRequestedTimeZone: timeZone];
    [self processDateTimeISO: conceptDict];
    
    //get final absolute date and time
    [self getFinalAbsoluteDate:_dateTimeFormatterDataObject];
    [self getFinalAbsoluteTime:_dateTimeFormatterDataObject];
    
    _dateTimeFormatterDataObject.showTimeInDate = _showTimeInDate;
    //generate final ISO8601 date string
    NSString* finalDateString = [_dateTimeFormatterDataObject generateFinalDateInISO8601Format];
    return finalDateString;
}

- (void)processDateTimeISO:(NSDictionary*)conceptDict
{
    //check for calendar object
    if([conceptDict conceptValueHasCalendarProperty]) {
        NSDictionary* partialDate = conceptDict[@"nuance_CALENDAR"];
        [self getFormattedDateTime: partialDate];
    }
    //check for calendar range object
    else if([conceptDict conceptValueHasCalendarRangeProperty]) {
        //calendar range handling goes here
        NSDictionary* partialDate = conceptDict[@"nuance_CALENDAR_RANGE"];
        [self getFormattedDateTimeWithRange:partialDate];
        
    }
}

- (void)getFormattedDateTime:(NSDictionary*) conceptDict
{
    /*
     Objective: Handles absolute and relative date-time
     */
    if([conceptDict conceptValueHasDateProperty]) {
        if([conceptDict conceptValueHasAbsDateProperty]) {
            //absolute date
            NSDictionary* partialDate = conceptDict[@"nuance_DATE"][@"nuance_DATE_ABS"];
            
            [_dateTimeFormatterDataObject parseAbsoluteDate:partialDate];
        }
        else if([conceptDict conceptValueHasRelDateProperty]) {
            //Relative date
            if(_dateTimeFormatterRefDataObject == nil)
                _dateTimeFormatterRefDataObject = [[DateTimeFormatterData alloc] init];
            
            NSDictionary* partialDate = conceptDict[@"nuance_DATE"][@"nuance_DATE_REL"];
            [self checkDataForRelativeDate:partialDate];
            [self processRelativeDate:_dateTimeFormatterDataObject isProcessingReference:NO];
        }
    }
    if([conceptDict conceptValueHasTimeProperty]) {
        _dateTimeFormatterDataObject.isServerTimeProvided=YES;
        if([conceptDict conceptValueHasAbsTimeProperty]) {
            NSDictionary* partialTime = conceptDict[@"nuance_TIME"][@"nuance_TIME_ABS"];
            [_dateTimeFormatterDataObject parseAbsoluteTime:partialTime];
        }
        else if([conceptDict conceptValueHasRelTimeProperty]) {
            NSDictionary* partialTime = conceptDict[@"nuance_TIME"][@"nuance_TIME_REL"];
            
            if(_dateTimeFormatterRefDataObject == nil)
                _dateTimeFormatterRefDataObject = [[DateTimeFormatterData alloc] init];
            
            [self checkDataForRelativeTime:partialTime];
            [self processRelativeTime:_dateTimeFormatterDataObject isProcessingReference:NO];
        }
    }
    else
    {
        _dateTimeFormatterDataObject.isServerTimeProvided=NO;
    }
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    /* Checks if date falls betwee begin date and end date */
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSInteger)compareDate:(NSDate*)firstDate andSecondDate:(NSDate*)andSecondDate
{
    /*
     Compares first date with the second date
     returns:
     -1, if date on the left is less than the date on the right.
     1, if date on the left is greater than the date on the right.
     0, if date on the left equals date on the right.
     */
    NSComparisonResult result = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]
                                 compareDate:firstDate
                                 toDate:andSecondDate
                                 toUnitGranularity:NSCalendarUnitMinute];
    
    return (NSInteger) result;
}

- (void)getFormattedDateTimeWithRange:(NSDictionary*)conceptDict
{
    /*
     Objective: Handles Fuzzy date-time data
     */
    NSString* startRangeDateTimeAsString = nil;
    NSString* endRangeDateTimeAsString =nil;
    NSDate* finalDateTime;
    NSDate* dateFromStartRange;
    NSDate* dateFromEndRange;
    NSUInteger startRangeHour = 0;
    NSUInteger startRangeDay = 0;
    NSUInteger startRangeMonth = 0;
    NSUInteger startRangeYear = 0;
    NSUInteger endRangeHour = 0;
    NSUInteger endRangeDay = 0;
    NSUInteger endRangeMonth = 0;
    NSUInteger endRangeYear = 0;
    NSDate* currentDateTime = _dateTimeFormatterDataObject.convertedDateTime;
    NSUInteger convertedHour = _dateTimeFormatterDataObject.convertedHour;
    NSUInteger convertedMonth = _dateTimeFormatterDataObject.convertedMonth ;
    NSUInteger convertedDay = _dateTimeFormatterDataObject.convertedDay;
    NSUInteger convertedYear = _dateTimeFormatterDataObject.convertedYear;
    BOOL isStartRangeProvided = [conceptDict conceptValueHasCalendarRangeStart];
    BOOL isEndRangeProvided = [conceptDict conceptValueHasCalendarRangeEnd];
    NSUInteger differenceInYear ;
    
    if(isEndRangeProvided) {
        NSDictionary* endRangeConcept = conceptDict[@"nuance_CALENDAR_RANGE_END"];
        
        if (endRangeConcept[@"nuance_CALENDAR"]) {
            endRangeConcept = endRangeConcept[@"nuance_CALENDAR"];
        }
        
        [self getFormattedDateTime:endRangeConcept];
        [self getFinalAbsoluteDate:_dateTimeFormatterDataObject];
        [self getFinalAbsoluteTime:_dateTimeFormatterDataObject];
        endRangeDateTimeAsString = [_dateTimeFormatterDataObject generateFinalDateInISO8601Format];
        dateFromEndRange = _dateTimeFormatterDataObject.serverDateTime;
        endRangeHour = _dateTimeFormatterDataObject.serverHour;
        endRangeDay = _dateTimeFormatterDataObject.serverDay;
        endRangeMonth = _dateTimeFormatterDataObject.serverMonth;
        endRangeYear = _dateTimeFormatterDataObject.serverYear;
    }
    if(isStartRangeProvided) {
        if(isEndRangeProvided) {
            NSTimeZone* timeZone = _dateTimeFormatterDataObject.timezoneRequested ;
            _dateTimeFormatterDataObject =  [[DateTimeFormatterData alloc]init];
            [_dateTimeFormatterDataObject convertDateTimeToRequestedTimeZone: timeZone];
            
            _dateTimeFormatterRefDataObject = nil;
        }
        NSDictionary* startRangeConcept = conceptDict[@"nuance_CALENDAR_RANGE_START"];
        
        if (startRangeConcept[@"nuance_CALENDAR"]) {
            startRangeConcept = startRangeConcept[@"nuance_CALENDAR"];
        }
        
        [self getFormattedDateTime:startRangeConcept];
        [self getFinalAbsoluteDate:_dateTimeFormatterDataObject];
        [self getFinalAbsoluteTime:_dateTimeFormatterDataObject];
        startRangeDateTimeAsString = [_dateTimeFormatterDataObject generateFinalDateInISO8601Format];
        dateFromStartRange = _dateTimeFormatterDataObject.serverDateTime;
        startRangeHour   = _dateTimeFormatterDataObject.serverHour;
        startRangeDay = _dateTimeFormatterDataObject.serverDay;
        startRangeMonth = _dateTimeFormatterDataObject.serverMonth;
        startRangeYear = _dateTimeFormatterDataObject.serverYear;
    }
    //case where both, start as well as end range is given
    if(isStartRangeProvided && isEndRangeProvided ) {
        if ([dateFromStartRange compare:dateFromEndRange] == NSOrderedDescending) {
            NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
            NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            /*
             Handle cases where start and end range is given and current date-time lies between start and end range.
             E.g. Book an appointment in July. And assume current date is July 25th. So the output should be current date with time as next complete hour.
             */
            if (startRangeYear   > endRangeYear)
            {
                differenceInYear = startRangeYear - endRangeYear;
                if(startRangeMonth > endRangeMonth)
                {
                    [dateComponents setYear:-differenceInYear-1];
                }
                else
                {
                    [dateComponents setYear:-differenceInYear];
                }
                dateFromStartRange  = [calendar dateByAddingComponents:dateComponents toDate:dateFromStartRange options:0];
                _dateTimeFormatterDataObject.serverDateTime= dateFromStartRange;
            }
            else
            {
                
                //[calendar setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
                if((convertedDay == endRangeDay ) || (endRangeDay-convertedDay==1))
                {
                    [dateComponents setDay:-1];
                    dateFromStartRange  = [calendar dateByAddingComponents:dateComponents toDate:dateFromStartRange options:0];
                    _dateTimeFormatterDataObject.serverDateTime= dateFromStartRange;
                }
                else
                {
                    [dateComponents setDay:1];
                    dateFromEndRange  = [calendar dateByAddingComponents:dateComponents toDate:dateFromEndRange options:0];
                }
            }
        }
        
        NSInteger  currentDateLessThanDateFromStartRange = [NLUDateTimeFormatter   compareDate:currentDateTime andSecondDate:dateFromStartRange];
        NSInteger  currentDateGreaterThanDateFromEndRange = [NLUDateTimeFormatter   compareDate:currentDateTime andSecondDate:dateFromEndRange];
        
        //range time has not been started yet
        if(currentDateLessThanDateFromStartRange <= 0) {
            finalDateTime  = dateFromStartRange;
        }
        //range time has already elapsed
        else
        {
            NSTimeInterval secondsBetweenCurrentDateTimeAndDateFromStartRange = [currentDateTime timeIntervalSinceDate:dateFromStartRange];
            int numberOfDays = secondsBetweenCurrentDateTimeAndDateFromStartRange / 86400;
            if(numberOfDays>0)
            {
                dateFromStartRange = currentDateTime;
            }
            
            if(currentDateGreaterThanDateFromEndRange == 1)
            {
                //add one day
                NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
                NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                [dateComponents setDay:1];
                finalDateTime  = [calendar dateByAddingComponents:dateComponents toDate:dateFromStartRange options:0];
            }
            //if current date time falls between start range and end range
            else if([NLUDateTimeFormatter date:currentDateTime isBetweenDate:dateFromStartRange andDate:dateFromEndRange])
            {
                //if current time is not in the last hour of the range, take the time as next completed hour
                if(convertedHour != endRangeHour)
                {
                    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
                    NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    [calendar setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
                    [dateComponents setDay:convertedDay];
                    [dateComponents setMonth:convertedMonth];
                    [dateComponents setYear:convertedYear];
                    //add one hour
                    [dateComponents setHour:convertedHour+1];
                    [dateComponents setMinute:0];
                    [dateComponents setSecond:0];
                    finalDateTime = [calendar dateFromComponents:dateComponents];
                }
                //if current time is in the last hour of the range, add a day to the start range datetime
                else
                {
                    //add one day
                    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
                    NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
                    [dateComponents setDay:1];
                    //[calendar setTimeZone:collectedDataObject.timezoneRequested];
                    finalDateTime  = [calendar dateByAddingComponents:dateComponents toDate:dateFromStartRange options:0];
                }
            }
            else
                finalDateTime = currentDateTime;
        }
    }
    //case when only the start range is given
    else if(isStartRangeProvided && !isEndRangeProvided) {
        NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
        
        if(_dateTimeFormatterDataObject.isServerTimeProvided) {
            //add one hour
            [dateComponents setHour:1];
        }
        else if(_dateTimeFormatterDataObject.isServerDayProvided) {
            //add one day to start date range
            [dateComponents setDay:1];
        }
        else if(_dateTimeFormatterDataObject.isServerMonthProvided) {
            [dateComponents setMonth:1];
        }
        else if(_dateTimeFormatterDataObject.isServerYearProvided) {
            [dateComponents setYear:1];
        }
        finalDateTime  = [calendar dateByAddingComponents:dateComponents toDate:dateFromStartRange options:0];
        if (!_dateTimeFormatterDataObject.isServerTimeProvided) {
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                           fromDate:finalDateTime];
            
            [dateComponents setHour:_defaultHour];
            [dateComponents setMinute:_defaultMinute];
            [dateComponents setSecond:_defaultSecond];
            
            [dateComponents setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
            finalDateTime = [calendar dateFromComponents:dateComponents];
            _dateTimeFormatterDataObject.isServerDayOfWeekSameAsCurrentDay = NO;
        }
    }
    //case when only the end range is given
    else
    {
        //take current date-time as final date-time
        finalDateTime = currentDateTime;
    }
    //repopulate the collection from the finalDate variable
    NSCalendar* calendarNewDate= [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    [calendarNewDate setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
    NSDateComponents *components = [calendarNewDate components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:finalDateTime];
    
    _dateTimeFormatterDataObject.serverDay = [components day];
    _dateTimeFormatterDataObject.serverMonth = [components month];
    _dateTimeFormatterDataObject.serverYear = [components year];
    
    _dateTimeFormatterDataObject.serverHour = [components hour];
    _dateTimeFormatterDataObject.serverMinute = [components minute];
    _dateTimeFormatterDataObject.serverSecond = [components second];
    _dateTimeFormatterDataObject.isServerDayProvided = YES;
    _dateTimeFormatterDataObject.isServerYearProvided=YES;
    _dateTimeFormatterDataObject.isServerMonthProvided=YES;
    _dateTimeFormatterDataObject.serverDateTime = finalDateTime;
    
}

- (void)getFinalAbsoluteDate:(DateTimeFormatterData*)collectedDataObject
{
    /*
     Objective: Applies rule for absolute date on the input data and preserves the data in the collection
     */
    NSInteger serverYear = collectedDataObject.serverYear;
    NSInteger serverMonth = collectedDataObject.serverMonth;
    NSInteger serverDay = collectedDataObject.serverDay;
    
    NSInteger convertedYear = _dateTimeFormatterDataObject.convertedYear;
    NSInteger convertedMonth = _dateTimeFormatterDataObject.convertedMonth;
    NSInteger convertedDay = _dateTimeFormatterDataObject.convertedDay;
    
    //#1 Year, month & date have been provided
    if ((serverYear != -1) && (serverMonth != -1) && (serverDay != -1)) {
        //do nothing.
    }
    //#2 Day and month provided (no year)
    else if (serverDay != -1 && serverMonth != -1 && serverYear == -1) {
        if (serverMonth == convertedMonth) {
            //if day is greater than current converted day, year must also be current converted year
            if(serverDay >= convertedDay)
            {
                collectedDataObject.serverYear = convertedYear;
            }
            else
            {
                //otherwise, year must be in the future. So increase the year by one
                collectedDataObject.serverYear = convertedYear + 1;
            }
        }
        //otherwise, if given month is greater then the current converted month, it means year must current converted year
        else if (serverMonth > convertedMonth) {
            collectedDataObject.serverYear = convertedYear;
        }
        else
        {
            collectedDataObject.serverYear = convertedYear + 1;
        }
    }
    //#3 day & year provided(no month)
    else if (serverYear != -1 && serverMonth == -1 && serverDay != -1) {
        if (serverYear == convertedYear) {
            collectedDataObject.serverMonth = convertedMonth;
            if (serverDay < convertedDay)
            {
                //add a month for the past date
                [self reconstructDateForGivenValues:serverYear month:convertedMonth + 1 day:serverDay collectedDataObject:collectedDataObject];
            }
        }
        else
        {
            collectedDataObject.serverMonth = 1;
        }
    }
    //#4 month and year provide(no day)
    else if (serverDay == -1 && serverMonth != -1 && serverYear != -1) {
        //if year and month both equals the converted month and year, it means day, too, would be current converted day
        if ((serverMonth == convertedMonth) && (serverYear == convertedYear)) {
            collectedDataObject.serverDay = convertedDay;
        }
        else
        {
            //otherwise, day would be very first day of the given month
            collectedDataObject.serverDay = 1;
        }
    }
    //#5 only day provided (no year and month)
    /*
     if day has not passed for the month, take current month and year
     Else, take next month
     */
    else if (serverYear == -1 && serverMonth == -1 && serverDay != -1) {
        collectedDataObject.serverYear = convertedYear;
        collectedDataObject.serverMonth = convertedMonth;
        
        if (serverDay < convertedDay) {
            //add a month for the past date
            [self reconstructDateForGivenValues:convertedYear month:convertedMonth + 1 day:serverDay collectedDataObject:collectedDataObject];
        }
    }
    //#6 only month provided(no day and year)
    else if (serverYear == -1 && serverMonth != -1 && serverDay == -1) {
        if (serverMonth == convertedMonth) {
            collectedDataObject.serverYear = convertedYear;
            collectedDataObject.serverDay = convertedDay;
        }
        else if (serverMonth > convertedMonth) {
            collectedDataObject.serverYear = convertedYear;
            //Take day as 1 when only month is provided and month is not the current month.
            collectedDataObject.serverDay = 1;
        }
        else
        {
            collectedDataObject.serverYear = convertedYear + 1;
            //Take day as 1 when only month is provided and month is not the current month.
            collectedDataObject.serverDay = 1;
        }
    }
    //#7 only year is provided(no month and day
    else if (serverYear != -1 && serverMonth == -1 && serverDay == -1) {
        if (serverYear == convertedYear) {
            collectedDataObject.serverMonth = convertedMonth;
            collectedDataObject.serverDay = convertedDay;
        }
        else
        {
            collectedDataObject.serverMonth = 1;
            collectedDataObject.serverDay = 1;
        }
    }
    //#8 no date parts provided
    else if (serverYear == -1 && serverMonth == -1 && serverDay == -1) {
        collectedDataObject.serverYear = convertedYear;
        collectedDataObject.serverMonth = convertedMonth;
        collectedDataObject.serverDay = convertedDay;
    }
    collectedDataObject.serverFullDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)collectedDataObject.serverYear, (long)collectedDataObject.serverMonth, (long)collectedDataObject.serverDay];
}

- (void)getFinalAbsoluteTime:(DateTimeFormatterData*)collectedDataObject
{
    /*
     Objective: Applies rule for absolute time on the input data and preserves the data in the collection
     */
    NSInteger serverHour = collectedDataObject.serverHour;
    NSInteger convertedHour = _dateTimeFormatterDataObject.convertedHour;
    BOOL isServerDayProvided = collectedDataObject.isServerDayProvided;
    NSInteger serverDay = collectedDataObject.serverDay;
    NSInteger serverYear = collectedDataObject.serverYear;
    NSInteger serverMonth = collectedDataObject.serverMonth;
    NSInteger serverMinute = collectedDataObject.serverMinute;
    NSInteger convertedMinute = _dateTimeFormatterDataObject.convertedMinute;
    
    //if time is not provided
    if (serverHour != -1) {
        //hour provided is of past time as compared to current time
        if ((serverHour < convertedHour) || ((serverHour == convertedHour) && (serverMinute < convertedMinute))) {
            //add a week to final date time if the time has been passed
            if (collectedDataObject.isServerDayOfWeekSameAsCurrentDay)
            {
                [self reconstructDateForGivenValues:serverYear month:serverMonth day:serverDay + 7 collectedDataObject:collectedDataObject];
                collectedDataObject.isServerDayOfWeekSameAsCurrentDay = NO;
            }
            else
                //no day part is provided
                if (isServerDayProvided == NO)
                {
                    //add a day to past time
                    [self reconstructDateForGivenValues:serverYear month:serverMonth day:serverDay + 1 collectedDataObject:collectedDataObject];
                }
        }
        else
        {
            //do nothing
        }
    }
    else
    {
        /* Jan 23, 2019
         Fix as per FLOR-6801
         Phrase "How busy is my schedule today?"
         Given: current time (say 5 am) is less than the default time (7 am)
         Output: system should show 7 AM instead of current time
         */
        
        if (_useCurrentTimeAsDefault) {
            //always take converted data from the main collection
            collectedDataObject.serverHour = _dateTimeFormatterDataObject.convertedHour;
            collectedDataObject.serverMinute = _dateTimeFormatterDataObject.convertedMinute;
            collectedDataObject.serverSecond = _dateTimeFormatterDataObject.convertedSecond;
        }
        else
        {
            if(([collectedDataObject.convertedFullDate isEqualToString:collectedDataObject.serverFullDate]) &&
               ((collectedDataObject.convertedHour > _defaultHour) || (collectedDataObject.convertedHour == _defaultHour && collectedDataObject.convertedMinute >= _defaultMinute)))
            {
                //always take converted data from the main collection
                collectedDataObject.serverHour = _dateTimeFormatterDataObject.convertedHour;
                collectedDataObject.serverMinute = _dateTimeFormatterDataObject.convertedMinute;
                collectedDataObject.serverSecond = _dateTimeFormatterDataObject.convertedSecond;
            }
            else
            {
                collectedDataObject.serverHour = _defaultHour;
                collectedDataObject.serverMinute = _defaultMinute;
                collectedDataObject.serverSecond =_defaultSecond;
            }
        }
    }
}

- (void)reconstructDateForGivenValues:(NSInteger) year month:(NSInteger)month day:(NSInteger)day collectedDataObject:(DateTimeFormatterData*) collectedDataObject
{
    /*
     Objective: Constructs a date for the data passed as input and populates relevant properties for the server data
     */
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //initialize timezone object for the given time zone abbreviation
    //NSTimeZone *timezone = collectedDataObject.timezoneRequested;
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    
    //[calendar setTimeZone:timezone];
    //construct date object from the date components
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:newDate];
    
    //Preserve the collected data
    collectedDataObject.serverYear = [components year];
    collectedDataObject.serverMonth = [components month];
    collectedDataObject.serverDay = [components day];
}

- (void)checkDataForRelativeDate:(NSDictionary *) partialDate
{
    /*
     Objective: Processes absolute or relative dates for REFERENCE type of concepts. It populates a separate collection for concepts under Reference
     */
    if ([partialDate isKindOfClass: [NSDictionary class]]) {
        if(partialDate[@"nuance_REFERENCE"]) {
            _dateTimeFormatterDataObject.isReferenceDateProvided = YES;
            if (partialDate[@"nuance_REFERENCE"][@"nuance_DATE"][@"nuance_DATE_ABS"])
            {
                NSDictionary* partialDateRef = partialDate[@"nuance_REFERENCE"][@"nuance_DATE"][@"nuance_DATE_ABS"];
                
                [_dateTimeFormatterRefDataObject parseAbsoluteDate:partialDateRef];
            }
            else if (partialDate[@"nuance_REFERENCE"][@"nuance_DATE"][@"nuance_DATE_REL"])
            {
                NSDictionary* partialDateRef = partialDate[@"nuance_REFERENCE"][@"nuance_DATE"][@"nuance_DATE_REL"];
                
                [_dateTimeFormatterRefDataObject parseRelativeDate:partialDateRef];
                [self processRelativeDate:_dateTimeFormatterRefDataObject isProcessingReference:YES];
            }
            [self getFinalAbsoluteDate:_dateTimeFormatterRefDataObject];
            _dateTimeFormatterRefDataObject.convertedFullDate = _dateTimeFormatterRefDataObject.serverFullDate;
        }
        [_dateTimeFormatterDataObject parseRelativeDate: partialDate];
    }
}


- (void)checkDataForRelativeTime:(NSDictionary *) partialTime
{
    /*
     Objective: Processes absolute or relative time for REFERENCE type of concepts. It populates a separate collection for concepts under Reference
     */
    
    if ([partialTime isKindOfClass: [NSDictionary class]]) {
        if (partialTime[@"nuance_REFERENCE"]) {
            _dateTimeFormatterDataObject.isReferenceTimeProvided = YES;
            if (partialTime[@"nuance_REFERENCE"][@"nuance_TIME"][@"nuance_TIME_ABS"])
            {
                NSDictionary* partialTimeRef = partialTime[@"nuance_REFERENCE"][@"nuance_TIME"][@"nuance_TIME_ABS"];
                [_dateTimeFormatterRefDataObject parseAbsoluteTime:partialTimeRef];
            }
            else if (partialTime[@"nuance_REFERENCE"][@"nuance_TIME"][@"nuance_TIME_REL"])
            {
                NSDictionary* partialTimeRef = partialTime[@"nuance_REFERENCE"][@"nuance_TIME"][@"nuance_TIME_REL"];
                [_dateTimeFormatterRefDataObject parseRelativeTime:partialTimeRef];
                [self processRelativeTime:_dateTimeFormatterRefDataObject isProcessingReference:YES];
            }
            [self getFinalAbsoluteTime:_dateTimeFormatterRefDataObject];
            if(_dateTimeFormatterDataObject.isReferenceDateProvided == NO)
            {
                _dateTimeFormatterRefDataObject.convertedFullDate = _dateTimeFormatterDataObject.convertedFullDate;
            }
            NSString * fullDateString = [NSString stringWithFormat:@"%@ %@", _dateTimeFormatterRefDataObject.convertedFullDate, _dateTimeFormatterRefDataObject.serverFullTime];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
            _dateTimeFormatterRefDataObject.convertedDateTime = [dateFormatter dateFromString:fullDateString];
        }
        
        [_dateTimeFormatterDataObject parseRelativeTime: partialTime ];
    }
}

- (void)processRelativeDate : (DateTimeFormatterData *) collectedDataObject isProcessingReference :(BOOL) isProcessingReference
{
    /*
     Objective: Prepares relative date data from the appropriate collection and preserves for use at later stage.
     */
    NSUInteger convertedDay = -1;
    NSUInteger convertedYear = -1;
    NSUInteger convertedMonth = -1;
    
    collectedDataObject.isServerDayProvided = YES;
    collectedDataObject.isServerMonthProvided=YES;
    collectedDataObject.isServerYearProvided=YES;
    if (collectedDataObject.isReferenceDateProvided == YES && isProcessingReference != YES) {
        convertedDay = _dateTimeFormatterRefDataObject.serverDay;
        convertedMonth = _dateTimeFormatterRefDataObject.serverMonth;
        convertedYear = _dateTimeFormatterRefDataObject.serverYear;
    }
    else
    {
        convertedDay = _dateTimeFormatterDataObject.convertedDay;
        convertedMonth = _dateTimeFormatterDataObject.convertedMonth;
        convertedYear = _dateTimeFormatterDataObject.convertedYear;
    }
    //Apply logic for relative date
    if(collectedDataObject.dayOfWeek !=-1) {
        NSInteger serverDayOfWeek = collectedDataObject.dayOfWeek;
        //NSInteger currentDayOfWeek = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitWeekday fromDate:[NSDate date]];
        
        /* May 25, 2018: Day of week being calculated is wrong when switching btween timezones'
         Used NSCalendar object with time zone set appropriately on the NSCalendar object
         */
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:_dateTimeFormatterDataObject.timezoneRequested];
        //---- end of change
        
        NSInteger currentDayOfWeek = [calendar component:NSCalendarUnitWeekday fromDate:[NSDate date]];
        
        /* May 28, 2018 collectedDataObject.convertedDay is 0 in case of reference objects.
         Actually, it should be taken from the variable "convertedDay" populated above appropriately; either from referece data or from actual data
         */
        //NSInteger currentDay = collectedDataObject.convertedDay;
        NSInteger currentDay = convertedDay;
        if(currentDayOfWeek == serverDayOfWeek) {
            //convertedDay = collectedDataObject.convertedDay;
            collectedDataObject.isServerDayOfWeekSameAsCurrentDay = YES;
        }
        else if(currentDayOfWeek < serverDayOfWeek) {
            convertedDay = currentDay + (serverDayOfWeek - currentDayOfWeek);
        }
        else
        {
            convertedDay = currentDay  + (7+serverDayOfWeek - currentDayOfWeek)%7;
        }
    }
    if(![collectedDataObject.stepForDate isEqual:@""] && collectedDataObject.incrementForDate !=-1) {
        NSUInteger increment = collectedDataObject.incrementForDate;
        
        if([collectedDataObject.stepForDate isEqual:@"day"]) {
            convertedDay = convertedDay + increment;
        }
        else if([collectedDataObject.stepForDate isEqual:@"week"]) {
            convertedDay = convertedDay + increment * 7;
        }
        else if([collectedDataObject.stepForDate isEqual:@"month"]) {
            convertedMonth = convertedMonth + increment;
        }
        else if([collectedDataObject.stepForDate isEqual:@"year"]) {
            convertedYear = convertedYear + increment;
        }
        
        [self reconstructDateForGivenValues:convertedYear month:convertedMonth day:convertedDay collectedDataObject:collectedDataObject];
    }
}


- (void)processRelativeTime : (DateTimeFormatterData *) collectedDataObject isProcessingReference :(BOOL) isProcessingReference
{
    /*
     Objective: Prepares relative time data from the appropriate collection and preserves for use at later stage.
     */
    NSDate *dateToProcess = [NSDate date];
    if (collectedDataObject.isReferenceTimeProvided == YES && isProcessingReference != YES) {
        dateToProcess = _dateTimeFormatterRefDataObject.convertedDateTime;
    }
    else
    {
        dateToProcess = _dateTimeFormatterDataObject.convertedDateTime;
    }
    
    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
    NSCalendar * calendar =[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    if(![collectedDataObject.stepForTime isEqual:@""] && collectedDataObject.incrementForTime !=-1) {
        NSUInteger increment = collectedDataObject.incrementForTime;
        
        if([collectedDataObject.stepForTime isEqual:@"minute"]) {
            [dateComponents setMinute: increment];
            
        }
        else if([collectedDataObject.stepForTime isEqual:@"hour"]) {
            
            [dateComponents setHour:increment];
        }
        [calendar setTimeZone:collectedDataObject.timezoneRequested];
        
        NSDate *finalDate = [calendar dateByAddingComponents:dateComponents toDate:dateToProcess options:0];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:finalDate];
        
        //Preserve the collected data
        /* Jan 23, 2019
         Fix for FLOR-6805. Handled cases where task time greater then 24 hours
         e.g. Remind me to recheck lungs in 300 hours.
         In such cases, since 300 hours comes out to be more than 12 days, so we need to preserve day/month/year as well.
         */
        collectedDataObject.serverDay = [components day];
        collectedDataObject.serverMonth = [components month];
        collectedDataObject.serverYear = [components year];
        
        //since date part has also been calculated using relative time, dayflag can be set to true.
        collectedDataObject.isServerDayProvided = YES;
        
        collectedDataObject.serverHour = [components hour];
        collectedDataObject.serverMinute = [components minute];
        collectedDataObject.serverSecond = [components second];
    }
}

@end



@implementation NSObject (DateTimeFormatHelper)

- (BOOL)conceptValueHasDateProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_DATE"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasTimeProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_TIME"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasAbsDateProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_DATE"][@"nuance_DATE_ABS"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasRelDateProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_DATE"][@"nuance_DATE_REL"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasAbsTimeProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_TIME"][@"nuance_TIME_ABS"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasRelTimeProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        NSDictionary *partialDate = (NSDictionary*) self;
        if (partialDate[@"nuance_TIME"][@"nuance_TIME_REL"]) {
            retVal  = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasCalendarProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        if (((NSDictionary*)self)[@"nuance_CALENDAR"]) {
            retVal = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasCalendarRangeProperty {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        if (((NSDictionary*)self)[@"nuance_CALENDAR_RANGE"]) {
            retVal = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasCalendarRangeStart {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        if (((NSDictionary*)self)[@"nuance_CALENDAR_RANGE_START"]) {
            retVal = YES;
        }
    }
    return retVal;
}

- (BOOL)conceptValueHasCalendarRangeEnd {
    BOOL retVal = NO;
    if ([self isKindOfClass: [NSDictionary class]]) {
        if (((NSDictionary*)self)[@"nuance_CALENDAR_RANGE_END"]) {
            retVal = YES;
        }
    }
    return retVal;
}

@end
