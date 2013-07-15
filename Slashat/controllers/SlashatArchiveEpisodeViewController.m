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

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.episode.episodeNumber];
    
    self.descriptionTextView.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
    NSString *descriptionString = [NSString stringWithFormat:@"%@\n%@", self.episode.itemDescription, self.episode.showNotes];
    self.descriptionTextView.text = [descriptionString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.titleLabel.text = [self.episode.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [formatter stringFromDate:self.episode.pubDate];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
        
    CGRect frame = self.descriptionTextView.frame;
    frame.size.height = self.descriptionTextView.contentSize.height - self.descriptionTextView.contentInset.bottom - self.descriptionTextView.contentInset.top;
    self.descriptionTextView.frame = frame;
    
    CGFloat contentHeight = self.descriptionTextView.contentSize.height + self.descriptionTextView.frame.origin.y;
    
    CGSize contentSize = CGSizeMake(0, contentHeight);
    
    [self.scrollView setContentSize:contentSize];
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
