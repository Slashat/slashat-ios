//
//  SlashatArchiveEpisodeViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-05.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatArchiveEpisodeViewController.h"
#import "AppDelegate.h"
#import "SlashatAudioControlViewController.h"

@interface SlashatArchiveEpisodeViewController ()

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
    
    self.navigationItem.title = self.episode.title;
    NSLog(@"rssItem.mediaUrl: %@", self.episode.mediaUrl);
    
    self.descriptionTextView.text = self.episode.itemDescription;
}

- (IBAction)playButtonPressed:(id)sender
{
    NSLog(@"Playbutton pressed!");
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    [appDelegate playSlashatAudioEpisode:self.episode];
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
