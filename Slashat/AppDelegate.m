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
@property (assign, nonatomic) BOOL isShowingAudioControlsView;

@property (weak, nonatomic) IBOutlet UIButton *hideShowAudioControlsButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *audioControlsSlider;
@property (weak, nonatomic) IBOutlet UIView *audioControlsContentView;
@property (weak, nonatomic) IBOutlet UIView *audioControlsView;

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
    UIColor *slashatNavigationBarColor = [UIColor colorWithRed:106/255.0f green:36/255.0f blue:12/255.0f alpha:1];
    [[UINavigationBar appearance] setTintColor:slashatNavigationBarColor];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Navigationbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIColor *textColor = [UIColor whiteColor];
    UIColor *textShadowColor = [UIColor colorWithWhite:255.0 alpha:0];
    
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
    
    if (!self.audioControlsView.superview) {        
        self.audioControlsView = [[[NSBundle mainBundle] loadNibNamed:@"SlashatAudioControlsView" owner:self options:nil] objectAtIndex:0];
        
        UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
        [tabBarController.view insertSubview:self.audioControlsView belowSubview:tabBarController.tabBar];
        
        CGRect audioControlsFrame = self.audioControlsView.frame;
        audioControlsFrame.origin.y = tabBarController.view.frame.size.height
                                    - tabBarController.tabBar.frame.size.height
                                    - self.audioControlsView.frame.size.height;
        self.audioControlsView.frame = audioControlsFrame;
        
        self.isShowingAudioControlsView = YES;
    }
}

#pragma mark - Actions

- (IBAction)playPauseButtonClicked:(id)sender
{
    if (self.audioHandler.isPlaying) {
        [self.audioHandler pause];
    } else {
        [self.audioHandler play];
    }
}

- (IBAction)hideShowAudioControlsButtonClicked:(id)sender
{
    CGRect newFrame = self.audioControlsView.frame;
    CGFloat audioControlsContentViewHeight = self.audioControlsContentView.frame.size.height;
    
    if (self.isShowingAudioControlsView) {
        newFrame.origin.y += audioControlsContentViewHeight;
    } else {
        newFrame.origin.y -= audioControlsContentViewHeight;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.audioControlsView.frame = newFrame;
    } completion:^(BOOL finished) {
        self.isShowingAudioControlsView = !self.isShowingAudioControlsView;
    }];
}

@end
