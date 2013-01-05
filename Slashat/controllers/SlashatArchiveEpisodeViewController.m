//
//  SlashatArchiveEpisodeViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-05.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatArchiveEpisodeViewController.h"

@interface SlashatArchiveEpisodeViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *embedWebView;
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
    
    [self.embedWebView loadHTMLString:[NSString stringWithFormat:@"<audio controls src='%@' />", self.rssItem.mediaUrl] baseURL:nil];
    [self.embedWebView setAllowsInlineMediaPlayback:YES];
    
    self.descriptionTextView.text = self.rssItem.itemDescription;
    //[embedWebView setMediaPlaybackAllowsAirPlay:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
