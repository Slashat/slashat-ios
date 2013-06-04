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

@end
