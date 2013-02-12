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
    
    [self fetchLiveStreams];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSLog(@"Frame: %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Bounds: %f, %f", self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)fetchLiveStreams
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bambuser.com/broadcast.json?username=slashat&type=live&limit=1&api_key=%@", BAMBUSER_TRANSCODE_API_KEY]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *broadcasts = [JSON valueForKeyPath:@"result"];
        
        if (broadcasts.count > 0) {
            NSString *broadcastId = [(id)[broadcasts objectAtIndex:0] valueForKeyPath:@"vid"];
            NSLog(@"Live stream active: %@", broadcastId);
            [self initializeLiveStream:broadcastId];
        } else {
            NSLog(@"No live streams active");
        }

    } failure:nil];
    
    [operation start];
}

- (void)initializeLiveStream:(NSString *)broadcastId
{
    NSURL *broadcastUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json", BAMBUSER_TRANSCODE_URL, broadcastId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:broadcastUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"api_key=%@&preset=hls", BAMBUSER_TRANSCODE_API_KEY];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
