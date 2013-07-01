//
//  FirstViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveViewController.h"
#import "SlashatCountdownViewController.h"
#import "AFJSONRequestOperation.h"
#import "APIKey.h"
#import "SlashatLiveVideoViewController.h"
#import <Social/Social.h>

const CGRect containerFrame = {{0.0f, 0.0f}, {320.0f, 240.0f}};

@interface SlashatLiveViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation SlashatLiveViewController

@synthesize embedWebView;

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
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    [self startLiveStreamOrCountdownAsync];
}

- (void)startLiveStreamOrCountdownAsync
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bambuser.com/broadcast.json"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"username=slashat&type=live&limit=1&api_key=%@", BAMBUSER_TRANSCODE_API_KEY];
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *broadcasts = [JSON valueForKeyPath:@"result"];
        
        if (broadcasts.count > 0) {
            NSString *broadcastId = [(id)[broadcasts objectAtIndex:0] valueForKeyPath:@"vid"];
            [self startLiveStream:broadcastId];
        } else {
            [self startCountdown];
        }
        
    } failure:nil];
    
    [operation start];
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
