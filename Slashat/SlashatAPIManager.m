//
//  SlashatAPIManager.m
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAPIManager.h"
#import "RSSParser.h"

@implementation SlashatAPIManager

+ (SlashatAPIManager *)sharedClient {
    static SlashatAPIManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SlashatAPIManager alloc] init];
    });
    
    return _sharedClient;
}

- (void)fetchArchiveEpisodesWithSuccess:(void (^)(NSArray *episodes))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"SlashatAPIManager: Fetching archive episodes");
    NSURL *url = [NSURL URLWithString:@"http://slashat.se/feed/podcast/slashat.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [RSSParser parseRSSFeedForRequest:request success:success failure:failure];
}



@end
