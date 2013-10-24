//
//  SlashatReceiveHighFiveViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatReceiveHighFiveViewController.h"
#import "SlashatHighFiveUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SlashatReceiveHighFiveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end

@implementation SlashatReceiveHighFiveViewController

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
    
    NSLog(@"%@", self.highFiveUser.qrCode);
    
    [self.qrCodeImageView setImageWithURL:self.highFiveUser.qrCode];
    
    self.navigationItem.title = [NSString stringWithFormat:@"High-Five %@!", self.highFiveUser.userName];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
