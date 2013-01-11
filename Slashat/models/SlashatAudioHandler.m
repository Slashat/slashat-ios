//
//  SlashatAudioHandler.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAudioHandler.h"
#import "MediaPlayer/MPMoviePlayerController.h"


@interface SlashatAudioHandler () {
    MPMoviePlayerController *player;
}

@end

@implementation SlashatAudioHandler

- (id)init
{
    if (self = [super init]) {
        player = [[MPMoviePlayerController alloc] init];
    }
    
    return self;
}

- (void)play
{
    [player play];
}

- (void)pause
{
    [player pause];
}

- (void)setEpisodeUrl:(NSURL *)episodeUrl
{
    [player setContentURL:episodeUrl];
    [player prepareToPlay];
}

@end
