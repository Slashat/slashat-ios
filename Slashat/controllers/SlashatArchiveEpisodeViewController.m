//
//  SlashatArchiveEpisodeViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-05.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatArchiveEpisodeViewController.h"
#import "AVFoundation/AVPlayer.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioSession.h"
#import "MediaPlayer/MPMoviePlayerController.h"

@interface SlashatArchiveEpisodeViewController () {
    MPMoviePlayerController *player;
}

@property (nonatomic, weak) IBOutlet UIWebView *embedWebView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

@end

@implementation SlashatArchiveEpisodeViewController

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
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = self.rssItem.title;
    NSLog(@"rssItem.mediaUrl: %@", self.rssItem.mediaUrl);
    
    //[self.embedWebView loadHTMLString:[NSString stringWithFormat:@"<audio controls src='%@' />", self.rssItem.mediaUrl] baseURL:nil];
    //[self.embedWebView setAllowsInlineMediaPlayback:YES];
        
    
    
    self.descriptionTextView.text = self.rssItem.itemDescription;
    //[embedWebView setMediaPlaybackAllowsAirPlay:YES];
}

-(IBAction)playButtonPressed:(id)sender
{
    NSLog(@"Playbutton pressed!");
    //player = [AVPlayer playerWithURL:self.rssItem.mediaUrl];
    //[player setAllowsExternalPlayback:YES];
    //[player setUsesExternalPlaybackWhileExternalScreenIsActive:YES];
    //[player addObserver:self forKeyPath:@"status" options:0 context:NULL];
    
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:self.rssItem.mediaUrl];
    [player prepareToPlay];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview:player.view];
    // ...
    [player play];
}

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusReadyToPlay) {
            [player play];
        } else if (player.status == AVPlayerStatusFailed) {
        }
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
