//
//  SlashatHighFive+RemoteAccessors.m
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFive+RemoteAccessors.h"
#import "SlashatAPIManager.h"

@implementation SlashatHighFive (RemoteAccessors)

+ (void)performHighFive:(SlashatHighFive *)highFive success:(VoidBlock)success failure:(ErrorBlock)errorBlock
{
    [[SlashatAPIManager sharedClient] performSlashatHighFive:highFive success:success failure:errorBlock];
}

@end
