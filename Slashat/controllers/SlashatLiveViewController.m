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

@end

@implementation SlashatLiveViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Live" image:nil tag:0];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Live_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Live_passive.png"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slashat_logo.png"]];
    
    [self startLiveStreamOrCountdownAsync];
}

- (void)startLiveStreamOrCountdownAsync
{
    [[SlashatAPIManager sharedClient] fetchLiveBroadcastIdWithSuccess:^(NSString *broadcastId) {
        if (broadcastId) {
            [self startLiveStream:broadcastId];
        }
        else {
            [self startCountdown];
        }
            
    } failure:nil];
}

- (void)startLiveStream:(NSString *)broadcastId
{
    NSLog(@"Starting live stream: %@", broadcastId);
    
    SlashatLiveVideoViewController *liveVideoViewController = (SlashatLiveVideoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatLiveVideoViewController"];
    
    [liveVideoViewController initializeLiveStream:broadcastId];
        
    [self addNewChildViewController:liveVideoViewController];
}


- (void)startCountdown
{
    NSLog(@"Starting countdown.");
    
    SlashatCountdownViewController *countdownViewController = (SlashatCountdownViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatCountdownViewController"];
    
    [self addNewChildViewController:countdownViewController];
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
