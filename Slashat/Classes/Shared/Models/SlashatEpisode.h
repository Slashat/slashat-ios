//
//  SlashatEpisode.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatEpisode : NSObject

@property (strong, nonatomic) NSNumber *episodeNumber;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *showNotes;
@property (strong, nonatomic) NSURL *link;
@property (strong, nonatomic) NSDate *pubDate;
@property (strong, nonatomic) NSString *guid;
@property (strong, nonatomic) NSURL *mediaUrl;
@property (strong, nonatomic) NSURL *podcastImage;

@end
