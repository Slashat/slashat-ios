//
//  SlashatLiveVideoViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-02-02.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveVideoViewController.h"
#import "MediaPlayer/MPMoviePlayerController.h"
#import "SlashatAPIManager.h"
#import "SlashatFullscreenMoviePlayerViewController.h"

@interface SlashatLiveVideoViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) SlashatFullscreenMoviePlayerViewController *fullscreenVideoViewController;

@end



@implementation SlashatLiveVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"Frame: %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)initializeLiveStream:(NSString *)broadcastId
{
    [[SlashatAPIManager sharedClient] fetchLiveStreamUrlForBroadcastId:broadcastId sucess:^(NSURL *streamUrl) {
        [self playStream:streamUrl];
    } failure:nil];
}

- (void)playStream:(NSURL *)streamUrl
{
    NSLog(@"Playing stream: %@", streamUrl);
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamUrl];
    
    [_moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview: _moviePlayer.view];
    
    [_moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
    [_moviePlayer prepareToPlay];
    [_moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [_moviePlayer setAllowsAirPlay:YES];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieExitedFullScreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieEnteredFullScreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];

    
    //[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)movieEnteredFullScreen:(NSNotification *)notification
{
    NSLog(@"movieEnteredFullScreen");
    
    if (!self.fullscreenVideoViewController) {
        self.fullscreenVideoViewController = [[SlashatFullscreenMoviePlayerViewController alloc] init];
    }
    
    [self.fullscreenVideoViewController.view addSubview:_moviePlayer.view];
    
    [self presentViewController:self.fullscreenVideoViewController animated:NO completion:nil];
}

- (void)movieExitedFullScreen:(NSNotification *)notification
{
    NSLog(@"movieExitedFullScreen");
    [self.view addSubview:_moviePlayer.view];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation
{
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [_moviePlayer setFullscreen:NO animated:YES];

    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        [_moviePlayer setFullscreen:YES animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
