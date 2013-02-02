//
//  FirstViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatLiveViewController.h"

@interface SlashatLiveViewController ()

@end

@implementation SlashatLiveViewController

@synthesize embedWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];

    
    /*[embedWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bambuser-embed" ofType:@"html"]isDirectory:NO]]];
    [embedWebView setAllowsInlineMediaPlayback:YES];
    embedWebView.scrollView.scrollEnabled = NO;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
