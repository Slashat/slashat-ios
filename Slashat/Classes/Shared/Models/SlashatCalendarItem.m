//
//  SlashatCalendarItem.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-14.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatCalendarItem.h"
#import "AFJSONRequestOperation.h"
#import "DateUtils.h"
#import "APIKey.h"

@implementation SlashatCalendarItem

+ (void)fetchNextSlashatCalendarItemWithSuccess:(void(^)(SlashatCalendarItem *calendarItem))success failure:(void(^)(NSError *error))failure
{
    NSString *parameterString = [NSString stringWithFormat:@"orderBy=startTime&singleEvents=true&timeMin=%@&key=%@", [DateUtils convertNSDateToGoogleCalendarString:[NSDate date]], GOOGLE_CALENDAR_API_KEY];
    
    NSString *encodedParameterString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)parameterString, NULL, CFSTR("+:"), kCFStringEncodingUTF8);
    
    NSString *calendarUrlString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/3om4bg9o7rdij1vuo7of48n910@group.calendar.google.com/events?%@", encodedParameterString];
    
    NSURL *calendarUrl = [NSURL URLWithString:calendarUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:calendarUrl];
    [request setHTTPMethod:@"GET"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSString *dateString = [[[(NSArray *)[JSON valueForKeyPath:@"items"] objectAtIndex:0] valueForKeyPath:@"start"] valueForKeyPath:@"dateTime"];
        
        SlashatCalendarItem *calendarItem = [[SlashatCalendarItem alloc] init];
        calendarItem.title = [[(NSArray *)[JSON valueForKeyPath:@"items"] objectAtIndex:0] valueForKeyPath:@"summary"];
        calendarItem.date = [DateUtils createNSDateFrom:dateString];
        
        success(calendarItem);
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
}

@end
