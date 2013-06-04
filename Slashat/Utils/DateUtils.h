//
//  DateUtils.h
//  Slashat
//
//  Created by Johan Larsson on 2013-06-04.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSDate *)createNSDateFrom:(NSString *)googleCalendarDateString;
+ (NSString *)convertNSDateToGoogleCalendarString:(NSDate *)date;


@end
