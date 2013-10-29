//
//  SlashatAboutHostProfileViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SlashatHost.h"

@interface SlashatAboutHostProfileViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) SlashatHost *host;

- (IBAction) twitterButtonPressed:(id)sender;
- (IBAction) webButtonPressed:(id)sender;
- (IBAction) mailButtonPressed:(id)sender;

@end
