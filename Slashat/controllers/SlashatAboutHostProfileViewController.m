//
//  SlashatAboutHostProfileViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAboutHostProfileViewController.h"

@interface SlashatAboutHostProfileViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UIButton *webButton;
@property (nonatomic, weak) IBOutlet UIButton *mailButton;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation SlashatAboutHostProfileViewController

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
    NSLog(@"SlashatAboutHostProfileViewController: viewDidLoad: Calling [super viewDidLoad]");
    [super viewDidLoad];
    
    NSLog(@"SlashatAboutHostProfileViewController: Setting nameLabel.text");
    self.nameLabel.text = self.host.name;
    
    NSLog(@"SlashatAboutHostProfileViewController: Setting descriptionTextView.text");
    self.descriptionTextView.text = self.host.longDescription;
    
    
    NSLog(@"SlashatAboutHostProfileViewController: Setting profileImageView");
    [self.profileImageView setImage:self.host.profileImage];
    
    NSLog(@"SlashatAboutHostProfileViewController: Setting content modes on image views");
    [self.twitterButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.webButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mailButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    NSLog(@"SlashatAboutHostProfileViewController: Setting navigationItem.title");
    self.navigationItem.title = self.host.name;
    
    NSLog(@"SlashatAboutHostProfileViewController: viewDidLoad: All set!");
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view layoutIfNeeded];
    self.textViewHeightConstraint.constant = self.descriptionTextView.contentSize.height;    
}

- (IBAction)twitterButtonPressed:(id)sender
{
    NSArray *twitterUrls = [self getTwitterAppUrlsForTwitterHandle:self.host.twitterHandle];
    
    for (NSURL *twitterUrl in twitterUrls) {
        if ([[UIApplication sharedApplication] canOpenURL:twitterUrl]) {
            [[UIApplication sharedApplication] openURL:twitterUrl];
            break;
        }
    }
}

- (NSArray *)getTwitterAppUrlsForTwitterHandle:(NSString *)twitterHandle
{
    NSURL *tweetbotUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@", twitterHandle]];
    NSURL *twitterifficUrl = [NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///profile?screen_name=%@", twitterHandle]];
    NSURL *twitterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"twitter:///user?screen_name=%@", twitterHandle]];
    
    NSURL *twitterWebUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", twitterHandle]];
    
    NSArray *twitterAppUrls = [NSArray arrayWithObjects:tweetbotUrl, twitterifficUrl, twitterUrl, twitterWebUrl, nil];
    
    return twitterAppUrls;
}

- (IBAction)webButtonPressed:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome:///"]]) {
        // Chrome is installed
        [[UIApplication sharedApplication] openURL:[self getChromeURIForUrl:self.host.link]];
    } else {
        [[UIApplication sharedApplication] openURL:self.host.link];
    }
}

- (NSURL *)getChromeURIForUrl:(NSURL *)url
{
    // Replace the URL Scheme with the Chrome equivalent.
    NSString *chromeScheme = nil;
    if ([url.scheme isEqualToString:@"http"]) {
        chromeScheme = @"googlechrome";
    } else if ([url.scheme isEqualToString:@"https"]) {
        chromeScheme = @"googlechromes";
    }
    
    NSURL *chromeUrl;
    
    // Proceed only if a valid Google Chrome URI Scheme is available.
    if (chromeScheme) {
        NSString *absoluteString = [url absoluteString];
        NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
        NSString *urlNoScheme =
        [absoluteString substringFromIndex:rangeForScheme.location];
        NSString *chromeURLString =
        [chromeScheme stringByAppendingString:urlNoScheme];
        chromeUrl = [NSURL URLWithString:chromeURLString];
    } else {
        chromeUrl = url;
    }
    
    return chromeUrl;
}


- (IBAction)mailButtonPressed:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlegmail:///"]]) {
        // Gmail-app is installed
        NSURL *gmailUrl = [NSURL URLWithString:[NSString stringWithFormat:@"googlegmail:///co?to=%@", self.host.emailAdress]];
        [[UIApplication sharedApplication] openURL:gmailUrl];
    } else {
        [self displayComposeMailSheet];
    }
    
}

- (void)displayComposeMailSheet
{
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    NSArray *toRecipients = [NSArray arrayWithObjects:self.host.emailAdress,
                             nil];
    
    [mailComposeViewController setToRecipients:toRecipients];
    
    [self presentViewController:mailComposeViewController animated:YES completion:nil];    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
