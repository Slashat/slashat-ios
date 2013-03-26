//
//  SlashatAudioControlViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-13.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlashatEpisode;

@interface SlashatAudioControlViewController : UIViewController

- (void)startPlayingEpisode:(SlashatEpisode *)episode;

@end
