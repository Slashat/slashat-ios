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
@property (weak, nonatomic) IBOutlet UIProgressView *audioControlsSlider;
@property (weak, nonatomic) IBOutlet UIView *audioControlsContentView;
@property (weak, nonatomic) IBOutlet UIView *audioControlsView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *episodeTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *playerActivityIndicator;


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

#pragma mark - URL Handling

- (BOOL)openURL:(NSURL *)url
{
    if ([url.scheme rangeOfString:@"googlechrome"].location != NSNotFound) {
        // Let SlashatApplication handle this in it's super UIApplication
        return NO;
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome:///"]]) {
        [[UIApplication sharedApplication] openURL:[self getChromeURIForUrl:url]];
        return YES;
    } else {
        return NO;
    }
}

- (NSURL *)getChromeURIForUrl:(NSURL *)url
{
    // Replace the URL Scheme with the Chrome equivalent.
    NSString *chromeScheme = nil;
    if ([url.scheme isEqualToString:@"http"]) {
        chromeScheme = @"googlechrome";
    } else if ([url.scheme isEqualToString:@"https"]) {
        chromeScheme = @"googlechromes";
    }
    
    NSURL *chromeUrl;
    
    // Proceed only if a valid Google Chrome URI Scheme is available.
    if (chromeScheme) {
        NSString *absoluteString = [url absoluteString];
        NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
        NSString *urlNoScheme =
        [absoluteString substringFromIndex:rangeForScheme.location];
        NSString *chromeURLString =
        [chromeScheme stringByAppendingString:urlNoScheme];
        chromeUrl = [NSURL URLWithString:chromeURLString];
    } else {
        chromeUrl = url;
    }
    
    return chromeUrl;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHandlerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.audioHandler.player];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHandlerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.audioHandler.player];
        
    }
    
    self.episodeTitle.text = [NSString stringWithFormat:@"Episod %d - %@", episode.episodeNumber, episode.title];
    
    [self setPlayerContentAlpha:0.2];
    self.playerActivityIndicator.hidden = NO;
}

-(void)audioHandlerLoadStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController* playerController = notification.object;
    
    if ([playerController loadState] & MPMovieLoadStatePlayable) {
        NSTimer *updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
        self.playerActivityIndicator.hidden = YES;
        [self setPlayerContentAlpha:1.0];
    }
}

-(void)audioHandlerPlaybackDidFinish:(NSNotification *)notification
{
    [self.audioControlsView removeFromSuperview];
}

-(void)setPlayerContentAlpha:(CGFloat)newAlpha
{
    self.progressLabel.alpha = newAlpha;
    self.timeLeftLabel.alpha = newAlpha;
    self.audioControlsSlider.alpha = newAlpha;
    self.episodeTitle.alpha = newAlpha;
    self.playPauseButton.alpha = newAlpha;
}

- (void)initializeProgressAndDuration
{
    
}

- (void)updateCurrentTime
{
    int currentPlaybackTime = (int)self.audioHandler.player.currentPlaybackTime;
    int timeLeft = (int)self.audioHandler.player.duration - currentPlaybackTime;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", currentPlaybackTime / (60*60), (currentPlaybackTime / 60) % 60, currentPlaybackTime % 60, nil];
    
    self.timeLeftLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d", timeLeft / (60*60), (timeLeft / 60) % 60, timeLeft % 60, nil];
    
    [self.audioControlsSlider setProgress:((float)currentPlaybackTime / (float)timeLeft) animated:YES];

    //self.audioControlsSlider.value = self.player.currentTime;
}

#pragma mark - Actions

- (IBAction)playPauseButtonClicked:(id)sender
{
    if (self.audioHandler.isPlaying) {
        [self.audioHandler pause];
        [self setPlayPauseButtonImage:@"Slashat_play.png"];
    } else {
        [self.audioHandler play];
        [self setPlayPauseButtonImage:@"Slashat_pause.png"];
    }
}

- (void)setPlayPauseButtonImage:(NSString *)imageName
{
    [self.playPauseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
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
