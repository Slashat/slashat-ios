//
//  SlashatHighFiveUser+RemoteAccessors.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFiveUser+RemoteAccessors.h"
#import "SlashatAPIManager.h"

@implementation SlashatHighFiveUser (RemoteAccessors)

+ (void)fetchUserWithSuccess:(UserObjectBlock)resultBlock onError:(UserErrorBlock)errorBlock;
{
    [[SlashatAPIManager sharedClient] fetchSlashatHighFiveUserWithSuccess:resultBlock failure:errorBlock];
}


@end
