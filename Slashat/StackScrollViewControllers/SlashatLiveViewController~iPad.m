//
//  SlashatLiveViewController~iPad.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveViewController~iPad.h"
#import "SlashatAPIManager.h"
#import "SlashatLiveVideoViewController.h"
#import "SlashatCountdownViewController.h"
#import "ColorUtils.h"

const CGRect ipadVideoContainerFrame = {{0.0f, 0.0f}, {477.0f, 268.0f}};

@interface SlashatLiveViewController_iPad ()

@property (nonatomic, assign) CGRect videoContainerFrame;

@end

@implementation SlashatLiveViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
		[self.view setFrame:frame];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [headerView setBackgroundColor:UIColorFromRGB(0xde5214)];
        [self.view addSubview:headerView];
        
        UIImage *slashatLogo = [UIImage imageNamed:@"logo_neg.png"];
        UIImageView *slashatLogoContainerView = [[UIImageView alloc] initWithImage:slashatLogo];
        slashatLogoContainerView.frame = CGRectMake(10, 10, slashatLogo.size.width, slashatLogo.size.height);
        [headerView addSubview:slashatLogoContainerView];
        
        self.videoContainerFrame = CGRectMake(0, headerView.frame.size.height, self.view.frame.size.width, 268.0f);
	}
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
    
    SlashatCountdownViewController *countdownViewController = (SlashatCountdownViewController *)[[SlashatCountdownViewController alloc] initWithNibName:@"CountdownView~iPad" bundle:nil];
    
    [self addNewChildViewController:countdownViewController];
}

- (void)addNewChildViewController:(UIViewController *)newChildViewController
{
    [self addChildViewController:newChildViewController];
    [self.view addSubview:newChildViewController.view];
    [newChildViewController didMoveToParentViewController:self];
    newChildViewController.view.frame = self.videoContainerFrame;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
