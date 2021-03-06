//
//  SlashatBadge.m
//  Slashat
//
//  Created by Johan Larsson on 2014-06-28.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import "SlashatBadge.h"

@implementation SlashatBadge

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = attributes[@"title"];
    self.description = attributes[@"description"];
    
    self.imageUrl = [NSURL URLWithString:attributes[@"picture"]];
    self.largeImageUrl = [NSURL URLWithString:attributes[@"picture_large"]];
    
    return self;
}

+ (NSArray *)initBadges:(NSDictionary *)attributes
{
    NSMutableArray *achievements = [NSMutableArray array];
    for (NSDictionary *attribute in attributes) {
        [achievements addObject:[[SlashatBadge alloc] initWithAttributes:attribute]];
    }
    
    return achievements;
}


@end
