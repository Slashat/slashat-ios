//
//  SlashatAudioControlViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-13.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAudioControlViewController.h"
#import "AppDelegate.h"
#import "SlashatEpisode.h"
#import "SlashatAudioHandler.h"

@interface SlashatAudioControlViewController ()
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) SlashatAudioHandler *audioHandler;
@property (strong, nonatomic) SlashatEpisode *episode;
@end

@implementation SlashatAudioControlViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.audioHandler = [[SlashatAudioHandler alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)playPauseButtonPressed:(id)sender
{
    [self.audioHandler pause];
}

- (void)startPlayingEpisode:(SlashatEpisode *)episode
{
    self.episode = episode;
    [self.audioHandler setEpisode:episode];
    [self.audioHandler play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
