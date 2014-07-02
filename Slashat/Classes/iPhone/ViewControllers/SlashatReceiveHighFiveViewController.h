//
//  SlashatReceiveHighFiveViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ZXingObjC/ZXingObjC.h>
#import "SlashatHighFiveUser.h"


@interface SlashatReceiveHighFiveViewController : UIViewController <ZXCaptureDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) SlashatHighFiveUser *highFiveUser;

- (IBAction)closeButtonPressed:(id)sender;

@end
