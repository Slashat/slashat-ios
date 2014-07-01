//
//  SlashatAchievementDetailViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2014-06-29.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlashatAchievement, SlashatBadge, SlashatHighFiveUser;

@interface SlashatAchievementDetailViewController : UIViewController

@property (strong, nonatomic) SlashatAchievement *achievement;
@property (strong, nonatomic) SlashatBadge *badge;

@property (strong, nonatomic) SlashatHighFiveUser *highFiveUser;

@end
