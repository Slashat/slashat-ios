//
//  AppDelegate.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SlashatAudioHandler.h"

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;


+ (AppDelegate *)sharedAppDelegate;
- (BOOL)openURL:(NSURL *)url;
- (void)playSlashatAudioEpisode:(SlashatEpisode *)episode;

@end
