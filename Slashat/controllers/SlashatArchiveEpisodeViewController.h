//
//  SlashatArchiveEpisodeViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-05.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlashatEpisode.h"

@interface SlashatArchiveEpisodeViewController : UIViewController

@property (nonatomic, strong) SlashatEpisode *episode;

- (IBAction) playButtonPressed:(id)sender;

@end
