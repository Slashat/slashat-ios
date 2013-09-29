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

+ (void)fetchAllHighFivers:(AllUsersBlock)successBlock onError:(UserErrorBlock)errorBlock
{
    [[SlashatAPIManager sharedClient] fetchAllSlashatHighFiversWithSuccess:successBlock failure:errorBlock];
}

+ (BOOL)userIsLoggedIn
{
    return [[SlashatAPIManager sharedClient] userIsLoggedIn];
}

+ (void)loginWithCredentials:(NSString *)username password:(NSString *)password success:(UserObjectBlock)successBlock onError:(UserErrorBlock)errorBlock
{
    [[SlashatAPIManager sharedClient] loginHighFiveUserWithCredentials:username password:password success:^(NSString *authToken) {
        [self fetchUserWithSuccess:successBlock onError:errorBlock];
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)saveTokenToKeyChain:(NSString *)authToken
{
    
}

@end
