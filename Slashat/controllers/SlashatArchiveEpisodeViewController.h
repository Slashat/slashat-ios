//
//  SlashatArchiveEpisodeViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-05.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSItem.h"

@interface SlashatArchiveEpisodeViewController : UIViewController

@property (nonatomic, strong) RSSItem *rssItem;

- (IBAction) playButtonPressed:(id)sender;

@end
