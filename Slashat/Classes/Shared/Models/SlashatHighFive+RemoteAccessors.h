//
//  SlashatHighFive+RemoteAccessors.h
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFive.h"

typedef void(^VoidBlock)();
typedef void(^ErrorBlock)(NSError *error);

@interface SlashatHighFive (RemoteAccessors)

+ (void)performHighFive:(SlashatHighFive *)highFive success:(VoidBlock)success failure:(ErrorBlock)errorBlock;

@end
