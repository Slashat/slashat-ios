//
//  SlashatAPIManager.h
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SlashatCalendarItem, SlashatHighFiveUser, SlashatHighFive;

@interface SlashatAPIManager : NSObject

@property (nonatomic, assign) BOOL useDevValues;

+ (SlashatAPIManager *)sharedClient;

- (void)fetchArchiveEpisodesWithSuccess:(void (^)(NSArray *episodes))success failure:(void (^)(NSError *error))failure;
- (void)fetchLiveBroadcastIdWithSuccess:(void (^)(NSString *broadcastId))success failure:(void (^)(NSError *error))failure;

- (void)fetchLiveStreamUrlForBroadcastId:(NSString *)broadcastId sucess:(void(^)(NSURL *streamUrl))success failure:(void (^)(NSError *error))failure;

- (void)loginHighFiveUserWithCredentials:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *authToken))success failure:(void(^)(NSError *error))failure;

- (void)fetchSlashatHighFiveUserWithSuccess:(void(^)(SlashatHighFiveUser *user))success failure:(void(^)(NSError *error))failure;
- (void)fetchAllSlashatHighFiversWithSuccess:(void(^)(NSArray *users))success failure:(void(^)(NSError *error))failure;

- (void)performSlashatHighFive:(SlashatHighFive *)highFive success:(void(^)())success failure:(void(^)(NSError *error))failure;

- (BOOL)userIsLoggedIn;

- (void)clearTokenFromKeychain;

@end
