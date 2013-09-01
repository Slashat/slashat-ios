//
//  SlashatBrowserViewController~iPad.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatBrowserViewController~iPad.h"

@interface SlashatBrowserViewController_iPad ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation SlashatBrowserViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.url = url;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame url:(NSURL *)url
{
    if (self = [super init]) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor whiteColor];
        [self loadUrl:url];
	}
    return self;
}

- (void)loadUrl:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadUrl:self.url];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
