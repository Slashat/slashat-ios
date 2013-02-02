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
    
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"]];
    [_moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
    [_moviePlayer prepareToPlay];
    [_moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [_moviePlayer setAllowsAirPlay:YES];
    
    [_moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview: _moviePlayer.view];
    [_moviePlayer play];
    
    NSLog(@"Frame: %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
