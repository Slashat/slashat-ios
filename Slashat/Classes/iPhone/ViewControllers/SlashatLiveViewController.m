//
//  FirstViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveViewController.h"
#import "SlashatCountdownViewController.h"
#import "SlashatAPIManager.h"
#import "SlashatLiveVideoViewController.h"
#import <Social/Social.h>

const CGRect containerFrame = {{0.0f, 0.0f}, {320.0f, 180.0f}};

@interface SlashatLiveViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSTimer *liveStreamCheckTimer;

@property (nonatomic, strong) SlashatCountdownViewController *countdownViewController;
@property (nonatomic, strong) SlashatLiveVideoViewController *liveVideoViewController;


@end

@implementation SlashatLiveViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        (void)[self.tabBarItem initWithTitle:@"Live" image:[UIImage imageNamed:@"tab-bar_live_inactive.png"] selectedImage:[UIImage imageNamed:@"tab-bar_live_active.png"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slashat_logo.png"]];
        
    [self startCountdown];
    [self startLiveStreamOrCountdownAsync];
}

- (void)startPeriodicLiveStreamCheck
{
    [self stopLiveStreamCheckTimer];
    
    self.liveStreamCheckTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(startLiveStreamOrCountdownAsync) userInfo:nil repeats:YES];
}

- (void)stopLiveStreamCheckTimer
{
    if (self.liveStreamCheckTimer) {
        [self.liveStreamCheckTimer invalidate];
        self.liveStreamCheckTimer = nil;
    }
}

- (void)startLiveStreamOrCountdownAsync
{
    [[SlashatAPIManager sharedClient] fetchLiveBroadcastIdWithSuccess:^(NSString *broadcastId) {
        if (broadcastId) {
            [self stopLiveStreamCheckTimer];
            [self startLiveStream:broadcastId];
        }
        else {
            [self startCountdown];
            [self startPeriodicLiveStreamCheck];
        }
            
    } failure:^(NSError *error) {
        [self startCountdown];
        [self startPeriodicLiveStreamCheck];
    }];
}

- (void)startLiveStream:(NSString *)broadcastId
{
    if (self.countdownViewController) {
        [self.countdownViewController.view removeFromSuperview];
        self.countdownViewController = nil;
    }
    
    if (!self.liveVideoViewController) {
        NSLog(@"Starting live stream: %@", broadcastId);
        
        self.liveVideoViewController = (SlashatLiveVideoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatLiveVideoViewController"];
        
        [self.liveVideoViewController initializeLiveStream:broadcastId];
        
        [self addNewChildViewController:self.liveVideoViewController];
    }    
}


- (void)startCountdown
{
    NSLog(@"Starting countdown.");
    
    if (!self.countdownViewController) {
        self.countdownViewController = (SlashatCountdownViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatCountdownViewController"];
        
        [self addNewChildViewController:self.countdownViewController];
    }
}

- (IBAction)shareOnTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet addURL:[NSURL URLWithString:@"http://live.slashat.se"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)shareOnFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebookSheet addURL:[NSURL URLWithString:@"http://live.slashat.se"]];
        
        [self presentViewController:facebookSheet animated:YES completion:Nil];
    }
}

- (void)addNewChildViewController:(UIViewController *)newChildViewController
{
    [self addChildViewController:newChildViewController];
    [self.containerView addSubview:newChildViewController.view];
    [newChildViewController didMoveToParentViewController:self];
    newChildViewController.view.frame = containerFrame;
}

- (void)removeChildViewController:(UIViewController *)childViewController
{
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
