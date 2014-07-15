//
//  SlashatEpisode.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatEpisode.h"

@implementation SlashatEpisode

- (NSString *)description
{
    return [NSString stringWithFormat:@"episodeNumber: %@\nepisodeTitle: %@\nmediaUrl: %@\npodcastImage: %@", self.episodeNumber, self.title, self.mediaUrl, self.podcastImage];
}

@end
