//
//  SlashatAudioControlViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-13.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlashatAudioHandler.h"

@interface SlashatAudioControlViewController : UIViewController

@property (nonatomic, strong) SlashatAudioHandler *audioHandler;

- (IBAction) playPauseButtonPressed:(id)sender;


@end
