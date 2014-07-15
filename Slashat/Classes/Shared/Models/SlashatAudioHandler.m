//
//  SlashatAudioHandler.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-11.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAudioHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <SDWebImage/SDWebImageDownloader.h>

@interface SlashatAudioHandler () {
    
}

@end

@implementation SlashatAudioHandler

- (id)init
{
    if (self = [super init]) {
        self.player = [[MPMoviePlayerController alloc] init];
        [[AVAudioSession sharedInstance] setDelegate: self];
        
        NSError *myErr;
        
        if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
            // Handle the error here.
            NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
        }
        else{
            // Since there were no errors initializing the session, we'll allow begin receiving remote control events
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }
        
        self.isPlaying = NO;
    }
    
    return self;
}

- (void)play
{
    [self.player play];
    
    self.isPlaying = YES;
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
                
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:self.episode.podcastImage options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            if (image && finished) {
                [self updateNowPlayingInfoWithTitle:self.episode.title albumArt:image];
            }
            
        }];
        
        [self updateNowPlayingInfoWithTitle:self.episode.title albumArt:nil];
    }
}

- (void)updateNowPlayingInfoWithTitle:(NSString *)title albumArt:(UIImage *)image
{
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    
    songInfo[MPMediaItemPropertyTitle] = title;
    songInfo[MPMediaItemPropertyArtist] = @"Slashat.se";
    
    if (image) {
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: image];
        songInfo[MPMediaItemPropertyArtwork] = albumArt;
    }
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

- (void)setEpisode:(SlashatEpisode *)episode
{
    _episode = episode;
    [self.player setContentURL:[_episode mediaUrl]];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)pause
{
    [self.player pause];
    self.isPlaying = NO;
}

@end
