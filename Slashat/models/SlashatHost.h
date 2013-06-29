//
//  SlashatHost.h
//  Slashat
//
//  Created by Johan Larsson on 2013-06-25.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatHost : NSObject

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) UIImage *profileImage;
@property (strong,nonatomic) NSString *shortDescription;
@property (strong,nonatomic) NSString *longDescription;

@end
