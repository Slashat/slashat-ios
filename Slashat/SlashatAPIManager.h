//
//  SlashatAPIManager.h
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlashatAPIManager : NSObject

+ (SlashatAPIManager *)sharedClient;

- (void)fetchArchiveEpisodesWithSuccess:(void (^)(NSArray *episodes))success failure:(void (^)(NSError *error))failure;

@end
