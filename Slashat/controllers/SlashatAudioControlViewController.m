//
//  SlashatAudioControlViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-13.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAudioControlViewController.h"

@interface SlashatAudioControlViewController ()

@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;

@end

@implementation SlashatAudioControlViewController

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
}

- (IBAction)playPauseButtonPressed:(id)sender
{
//    [self.audioHandler pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
