//
//  SlashatHighFiveUser.h
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatHighFiveUser : NSObject

@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger userId;

@property (strong, nonatomic) NSString *highfivedByName;
@property (strong, nonatomic) NSDate *highfivedDate;
@property (strong, nonatomic) NSString *highfivedWhere;

@property (strong, nonatomic) NSURL *profilePicture;
@property (strong, nonatomic) NSURL *qrCode;

@property (strong, nonatomic) NSArray *highFivers;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *)initUsersSortedByUserIdWithAttributes:(NSDictionary *)attributes;

@end
