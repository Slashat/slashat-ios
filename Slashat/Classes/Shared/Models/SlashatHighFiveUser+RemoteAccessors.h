//
//  SlashatHighFiveUser+RemoteAccessors.h
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFiveUser.h"

typedef void(^UserObjectBlock)(SlashatHighFiveUser *user);
typedef void(^AllUsersBlock)(NSArray *highFivers);
typedef void(^UserErrorBlock)(NSError *error);


@interface SlashatHighFiveUser (RemoteAccessors)

+ (void)fetchUserWithSuccess:(UserObjectBlock)successBlock onError:(UserErrorBlock)errorBlock;
+ (void)fetchAllHighFivers:(AllUsersBlock)successBlock onError:(UserErrorBlock)errorBlock;
+ (void)loginWithCredentials:(NSString *)username password:(NSString *)password success:(UserObjectBlock)successBlock onError:(UserErrorBlock)errorBlock;
+ (BOOL)userIsLoggedIn;

+ (void)logOutUser;


@end
