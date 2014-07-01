//
//  SlashatBadge.h
//  Slashat
//
//  Created by Johan Larsson on 2014-06-28.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatBadge : NSObject

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSURL *largeImageUrl;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

+ (NSArray *)initBadges:(NSDictionary *)attributes;

@end
