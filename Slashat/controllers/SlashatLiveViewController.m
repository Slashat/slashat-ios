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

const CGRect containerFrame = {{0.0f, 0.0f}, {320.0f, 240.0f}};

@interface SlashatLiveViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@end

@implementation SlashatLiveViewController

@synthesize embedWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
    
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
    
    SlashatLiveViewController *liveVideoViewController = (SlashatLiveViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatLiveVideoViewController"];
    
    [self addNewChildViewController:liveVideoViewController];
}


- (void)startCountdown
{
    NSLog(@"Starting countdown.");
    
    SlashatCountdownViewController *countdownViewController = (SlashatCountdownViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SlashatCountdownViewController"];
    
    [self addNewChildViewController:countdownViewController];
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
