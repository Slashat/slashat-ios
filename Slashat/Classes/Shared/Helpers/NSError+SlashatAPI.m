//
//  NSError+SlashatAPI.m
//  Slashat
//
//  Created by Johan Larsson on 2013-10-20.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "NSError+SlashatAPI.h"

@implementation NSError (SlashatAPI)

- (id)initWithAttributes:(NSDictionary *)attributes
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:[attributes valueForKey:@"message"] forKey:NSLocalizedDescriptionKey];
    
    self = [self initWithDomain:@"slashat.se" code:100 userInfo:errorDetail];
    if (!self) {
        return nil;
    }
    
    return self;
}

@end
