//
//  SlashatAchievement.m
//  Slashat
//
//  Created by Johan Larsson on 2014-06-28.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import "SlashatAchievement.h"

@implementation SlashatAchievement

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = attributes[@"name"];
    self.imageUrl = [NSURL URLWithString:attributes[@"picture"]];
    self.achieved = [attributes[@"achieved"] boolValue];
    
    return self;
}

+ (NSArray *)initAchievements:(NSDictionary *)attributes
{
    NSMutableArray *achievements = [NSMutableArray array];
    for (NSDictionary *attribute in attributes) {
        [achievements addObject:[[SlashatAchievement alloc] initWithAttributes:attribute]];
    }
    
    return achievements;
}

@end
