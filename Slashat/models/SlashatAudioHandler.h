//
//  SlashatAudioHandler.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlashatEpisode.h"
#import "MediaPlayer/MPMoviePlayerController.h"

@interface SlashatAudioHandler : NSObject

@property (strong, nonatomic) MPMoviePlayerController *player;

@property (strong, nonatomic) SlashatEpisode *episode;
@property (assign, nonatomic) BOOL isPlaying;

- (void)play;
- (void)pause;

@end
