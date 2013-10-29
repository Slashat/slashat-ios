//
//  SlashatHighFive.h
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SlashatHighFive : NSObject

@property (strong, nonatomic) NSString *receiverToken;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
