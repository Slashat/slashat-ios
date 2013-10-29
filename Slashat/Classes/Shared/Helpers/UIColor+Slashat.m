//
//  UIColor+Slashat.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "UIColor+Slashat.h"
#import "ColorUtils.h"

@implementation UIColor (Slashat)

+ (UIColor *)slashatOrange
{
    return [UIColor colorWithRed:222/255.0f green:82/255.0f blue:20/255.0f alpha:1];
    //return UIColorFromRGB(0xde5214);
}

+ (UIColor *)highFiveFeedbackGoodTextColor
{
    return [UIColor colorWithRed:128/255.0f green:255/255.0f blue:0/255.0f alpha:1];
}

+ (UIColor *)highFiveFeedbackBadTextColor
{
    return [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1];
}

@end
