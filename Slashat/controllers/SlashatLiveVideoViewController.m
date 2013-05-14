//
//  SlashatLiveVideoViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-02-02.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveVideoViewController.h"
#import "APIKey.h"
#import "MediaPlayer/MPMoviePlayerController.h"
#import "AFJSONRequestOperation.h"

@interface SlashatLiveVideoViewController ()

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

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
    NSURL *broadcastUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json", BAMBUSER_TRANSCODE_URL, broadcastId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:broadcastUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"api_key=%@&preset=hls", BAMBUSER_TRANSCODE_API_KEY];
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"Bambuser url: %@", [[JSON valueForKeyPath:@"result"] valueForKeyPath:@"url"]);
        [self playStream:[NSURL URLWithString:[[JSON valueForKeyPath:@"result"] valueForKeyPath:@"url"]]];
    } failure:nil];
    
    [operation start];
}

- (void)playStream:(NSURL *)streamUrl
{
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamUrl];
    [_moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
    [_moviePlayer prepareToPlay];
    [_moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [_moviePlayer setAllowsAirPlay:YES];
    
    [_moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview: _moviePlayer.view];
    [_moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieExitedFullScreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieEnteredFullScreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)movieEnteredFullScreen:(NSNotification *)notification
{
    NSLog(@"movieEnteredFullScreen");
}

- (void)movieExitedFullScreen:(NSNotification *)notification
{
    NSLog(@"movieExitedFullScreen");
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
