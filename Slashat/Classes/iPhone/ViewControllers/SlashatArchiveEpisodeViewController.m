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
#import <Social/Social.h>

@interface SlashatArchiveEpisodeViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"#%@", self.episode.episodeNumber];
    
    
    //self.descriptionTextView.contentInset = UIEdgeInsetsMake(120, 0, 120, 0);
    self.descriptionTextView.textContainerInset = UIEdgeInsetsMake(120, 6, 80, 6);
    self.descriptionTextView.scrollIndicatorInsets = UIEdgeInsetsMake(120, 0, 55, 0);
    
    NSString *descriptionString = [NSString stringWithFormat:@"%@\n%@", self.episode.itemDescription, self.episode.showNotes];
    self.descriptionTextView.text = [descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.titleLabel.text = [self.episode.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.titleLabel sizeToFit];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [formatter stringFromDate:self.episode.pubDate];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view layoutIfNeeded];
    //self.textViewHeightConstraint.constant = [self.descriptionTextView sizeThatFits:CGSizeMake(self.descriptionTextView.frame.size.width, FLT_MAX)].height;
}

- (IBAction)shareButtonPressed:(id)sender
{
    if (self.episode.link) {
        NSLog(@"Share button pressed: %@", self.episode.link);
        NSArray *dataToShare = @[[self.episode.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], self.episode.link];
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                          applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:^{}];
    }
}

- (IBAction)playButtonPressed:(id)sender
{
    NSLog(@"Playbutton pressed! Media-url: %@", self.episode.mediaUrl);
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    
    [appDelegate playSlashatAudioEpisode:self.episode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
