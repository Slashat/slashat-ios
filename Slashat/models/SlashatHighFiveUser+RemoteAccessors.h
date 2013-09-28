//
//  SlashatHighFiveUser+RemoteAccessors.h
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFiveUser.h"

typedef void(^UserObjectBlock)(SlashatHighFiveUser *user);
typedef void(^UserErrorBlock)(NSError *error);


@interface SlashatHighFiveUser (RemoteAccessors)

+ (void)fetchUserWithSuccess:(UserObjectBlock)successBlock onError:(UserErrorBlock)errorBlock;

@end
