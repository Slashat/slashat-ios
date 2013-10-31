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
    self.userId = [[attributes valueForKey:@"user_id"] integerValue];
    
    self.highfivedByName = [attributes valueForKey:@"highfived_by_name"];
    
    if ([attributes valueForKey:@"highfived_date"] && [attributes valueForKey:@"highfived_date"] != [NSNull null]) {
        self.highfivedDate = [NSDate dateWithTimeIntervalSince1970:[[attributes valueForKey:@"highfived_date"] doubleValue]];
    }
    
    self.highfivedWhere = [attributes valueForKey:@"highfived_where"];
    
    if ([attributes valueForKey:@"picture"] && [attributes valueForKey:@"picture"] != [NSNull null]) {
        self.profilePicture = [NSURL URLWithString:[attributes valueForKey:@"picture"]];
    }
    
    if ([attributes valueForKey:@"qrcode"]) {
        self.qrCode = [NSURL URLWithString:[attributes valueForKey:@"qrcode"]];
    }
    
    self.highFivers = [SlashatHighFiveUser initUsersWithAttributes:[attributes objectForKey:@"highfivers"]];
    
    return self;
}

+ (NSArray *)initUsersWithAttributes:(NSDictionary *)attributes
{
    NSMutableArray *highFivers = [NSMutableArray array];
    for (NSString *highFiverKey in attributes) {
        NSDictionary *highFiverAttributes = [attributes objectForKey:highFiverKey];
        [highFivers addObject:[[SlashatHighFiveUser alloc] initWithAttributes:highFiverAttributes]];
    }
    
    NSSortDescriptor *lowestIdToHighest = [NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES];
    [highFivers sortUsingDescriptors:[NSArray arrayWithObject:lowestIdToHighest]];
    
    return highFivers;
}

@end
