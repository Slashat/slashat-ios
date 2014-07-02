//
//  DateUtils.m
//  Slashat
//
//  Created by Johan Larsson on 2013-06-04.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSDate *)createNSDateFrom:(NSString *)googleCalendarDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
            
    return [formatter dateFromString:googleCalendarDateString];
}

+ (NSString *)convertNSDateToGoogleCalendarString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    
    return [formatter stringFromDate:date];
}

+ (NSString *)convertNSDateToFriendlyString:(NSDate *)date
{
    NSTimeInterval timeSinceDate = - [date timeIntervalSinceNow];
    
    if(timeSinceDate < 48.0 * 60.0 * 60.0)
    {
        NSUInteger hoursSinceDate = (NSUInteger)(timeSinceDate / (60.0 * 60.0));
        
        switch(hoursSinceDate)
        {
            default: return [NSString stringWithFormat:@"%lu timmar sedan", (unsigned long)hoursSinceDate];
            case 1: return @"1 timma sedan";
            case 0: return [NSString stringWithFormat:@"%lu minuter sedan", (unsigned long)(timeSinceDate / 60.0)];
        }
    }
    else
    {
        NSUInteger daysSinceDate = (NSUInteger)(timeSinceDate / (24.0 * 60.0 * 60.0));
        return [NSString stringWithFormat:@"%lu dagar sedan", (unsigned long)daysSinceDate];
    }    
}

@end
