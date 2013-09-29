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
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSURL *profilePicture;
@property (strong, nonatomic) NSURL *qrCode;

@property (strong, nonatomic) NSArray *highFivers;

@end
