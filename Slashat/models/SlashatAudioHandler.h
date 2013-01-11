//
//  SlashatAudioHandler.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatAudioHandler : NSObject

@property (strong,nonatomic) NSURL *episodeUrl;

- (void)play;
- (void)pause;


@end
