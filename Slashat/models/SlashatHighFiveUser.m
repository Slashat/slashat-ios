//
//  SlashatHighFiveUser.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFiveUser.h"

@implementation SlashatHighFiveUser

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
        
    self.userName = [attributes valueForKey:@"username"];
    self.userId = [attributes valueForKey:@"user_id"];
    
    self.highfivedByName = [attributes valueForKey:@"highfived_by_name"];
        
    self.highfivedDate = [NSDate dateWithTimeIntervalSince1970:[[attributes valueForKey:@"highfived_date"] doubleValue]];
    self.highfivedWhere = [attributes valueForKey:@"highfived_where"];
    
    if ([attributes valueForKey:@"picture"] && [attributes valueForKey:@"picture"] != [NSNull null]) {
        self.profilePicture = [NSURL URLWithString:[attributes valueForKey:@"picture"]];
    }
    
    if ([attributes valueForKey:@"qrcode"]) {
        self.qrCode = [NSURL URLWithString:[attributes valueForKey:@"qrcode"]];
    }
    
    NSMutableArray *highFivers = [[NSMutableArray alloc] init];
    for (NSString *highFiverAttributes in [attributes objectForKey:@"highfivers"]) {
        [highFivers addObject:[[SlashatHighFiveUser alloc] initWithAttributes:[[attributes objectForKey:@"highfivers"]objectForKey:highFiverAttributes]]];
    }
    
    self.highFivers = highFivers;
    
    return self;
}

@end
