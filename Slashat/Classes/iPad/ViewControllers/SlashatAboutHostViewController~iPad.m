//
//  SlashatAboutHostViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAboutHostViewController~iPad.h"
#import "SlashatHost.h"

@interface SlashatAboutHostViewController_iPad ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (nonatomic, weak) IBOutlet UIButton *twitterButton;
@property (nonatomic, weak) IBOutlet UIButton *webButton;
@property (nonatomic, weak) IBOutlet UIButton *mailButton;


@end

@implementation SlashatAboutHostViewController_iPad

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
    
    self.descriptionTextView.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
    self.descriptionTextView.text = self.host.longDescription;
        
    [self.profileImageView setImage:[UIImage imageNamed:self.host.profileThumbnailImageName]];
    
    [self.twitterButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.webButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mailButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view layoutIfNeeded];
    self.textViewHeightConstraint.constant = self.descriptionTextView.contentSize.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
