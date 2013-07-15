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
    [super viewDidLoad];
    
    self.nameLabel.text = self.host.name;
    self.descriptionTextView.text = self.host.longDescription;
    [self.profileImageView setImage:self.host.profileImage];
    
    [self.twitterButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.webButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mailButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.navigationItem.title = self.host.name;
    
    CGRect frame;
    frame = self.descriptionTextView.frame;
    frame.size.height = [self.descriptionTextView contentSize].height;
    self.descriptionTextView.frame = frame;    
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

- (IBAction) twitterButtonPressed:(id)sender
{
    
}

- (IBAction) webButtonPressed:(id)sender
{
    
}

- (IBAction) mailButtonPressed:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
