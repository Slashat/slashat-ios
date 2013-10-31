//
//  SlashatCalendarItem.h
//  Slashat
//
//  Created by Johan Larsson on 2013-09-14.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatCalendarItem : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;

+ (void)fetchNextSlashatCalendarItemWithSuccess:(void(^)(SlashatCalendarItem *calendarItem))success failure:(void(^)(NSError *error))failure;

@end
