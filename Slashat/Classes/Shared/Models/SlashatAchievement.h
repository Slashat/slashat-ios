//
//  SlashatAchievement.h
//  Slashat
//
//  Created by Johan Larsson on 2014-06-28.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatAchievement : NSObject

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL achieved;

+ (NSArray *)initAchievements:(NSDictionary *)attributes;

@end
