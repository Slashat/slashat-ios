//
//  AppDelegate.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()
@property (strong, nonatomic) SlashatAudioHandler *audioHandler;
@property (strong, nonatomic) MPVolumeView *audioControllerView;
@property (assign, nonatomic) BOOL isShowingAudioControllerView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [self setCustomNavigationBarAppearance];
    
    //NSError *sessionError = nil;
    //[[AVAudioSession sharedInstance] setDelegate:self];
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    // Changing the default output audio route
    //
    //UInt32 doChangeDefaultRoute = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    // Override point for customization after application launch.
    return YES;
}

- (void)setCustomNavigationBarAppearance
{
    UIColor *slashatNavigationBarColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    [[UINavigationBar appearance] setTintColor:slashatNavigationBarColor];
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *textShadowColor = [UIColor colorWithWhite:255.0 alpha:0.8];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: textColor,
                          UITextAttributeTextShadowColor: textShadowColor,
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]
     }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: textColor,
                          UITextAttributeTextShadowColor: textShadowColor,
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]}
                                                forState: UIControlStateNormal];
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Audio handler

- (void)playSlashatAudioEpisode:(SlashatEpisode *)episode
{
    if (!self.audioHandler) {
        self.audioHandler = [[SlashatAudioHandler alloc] init];
    }
    
    [self.audioHandler setEpisode:episode];
    [self.audioHandler play];
    
    CGSize applicationFrameSize = [UIScreen mainScreen].bounds.size;
    CGFloat audioControllerHeight = 40.0f; // This is the minimized height, the full height i 100
    // 49 = tab bar height, 20 = status bar height
    CGFloat audioControllerOriginY = applicationFrameSize.height - audioControllerHeight - 49.0f;
    CGRect audioControllerFrame = CGRectMake(0.0f,
                                             audioControllerOriginY,
                                             applicationFrameSize.width,
                                             audioControllerHeight);
    
    if (!self.audioControllerView) {
        self.audioControllerView = [[MPVolumeView alloc] initWithFrame:audioControllerFrame];
        self.audioControllerView.showsRouteButton = YES;
        self.audioControllerView.showsVolumeSlider = YES;
        self.audioControllerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        
        UIButton *playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        playPauseButton.frame = CGRectMake(48.0f, 20.0f, 100.0f, 60.0f);
        [playPauseButton setTitle:@"Play/Pause" forState:UIControlStateNormal];
        [playPauseButton addTarget:self
                            action:@selector(playPauseAudio:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.audioControllerView addSubview:playPauseButton];
        
        UIButton *hideShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        hideShowButton.frame = CGRectMake(0.0f, 0.0f, applicationFrameSize.width, 40.0f);
        [hideShowButton setTitle:@"Hide/Show" forState:UIControlStateNormal];
        [hideShowButton addTarget:self
                           action:@selector(hideShowAudioControllerView:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.audioControllerView addSubview:hideShowButton];
    }
    
    [self.window.rootViewController.view addSubview:self.audioControllerView];
    self.isShowingAudioControllerView = NO;
}

- (IBAction)playPauseAudio:(id)sender
{
    if (self.audioHandler.isPlaying) {
        [self.audioHandler pause];
    } else {
        [self.audioHandler play];
    }
}

- (IBAction)hideShowAudioControllerView:(id)sender
{
    NSTimeInterval duration = 0.2;
    CGFloat fullHeight = 100.0f;
    CGFloat minimizedHeight = 40.0f;
    CGFloat heightChange = fullHeight - minimizedHeight;
    BOOL newShowStatus;

    CGRect newFrame = self.audioControllerView.frame;
    
    if (self.isShowingAudioControllerView) {
        newFrame.size.height = minimizedHeight;
        newFrame.origin.y += heightChange;
        newShowStatus = NO;
    } else {
        newFrame.size.height = fullHeight;
        newFrame.origin.y -= heightChange;
        newShowStatus = YES;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.audioControllerView.frame = newFrame;
    } completion:^(BOOL finished) {
        self.isShowingAudioControllerView = newShowStatus;
    }];
}

@end
