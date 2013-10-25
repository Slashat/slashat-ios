//
//  SlashatAPIManager.m
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAPIManager.h"
#import "AFJSONRequestOperation.h"
#import "RSSParser.h"
#import "APIKey.h"
#import "SlashatHost.h"
#import "SlashatCalendarItem.h"
#import "DateUtils.h"
#import "SlashatHighFiveUser.h"
#import <Security/Security.h>
#import "KDJKeychainItemWrapper.h"
#import "SlashatHighFive.h"
#import "NSError+SlashatAPI.h"

@interface SlashatAPIManager ()

@property (strong, nonatomic) NSString *highFiveAuthToken;
@property (strong, nonatomic) KDJKeychainItemWrapper *tokenKeyChainItem;

@end

@implementation SlashatAPIManager

@synthesize highFiveAuthToken = _highFiveAuthToken;

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

- (void)fetchLiveBroadcastIdWithSuccess:(void (^)(NSString *broadcastId))success failure:(void (^)(NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bambuser.com/broadcast.json"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *userName = self.useDevValues ? @"slashat_dev" : @"slashat";
    NSString *apiKey = self.useDevValues ? BAMBUSER_DEV_API_KEY : BAMBUSER_TRANSCODE_API_KEY;
    
    NSLog(@"Fetching live broadcastId for user %@", userName);
    
    NSString *postParams = [NSString stringWithFormat:@"username=%@&type=live&limit=1&api_key=%@", userName, apiKey];
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *broadcasts = [JSON valueForKeyPath:@"result"];
        
        if (broadcasts.count > 0) {
            NSString *broadcastId = [(id)[broadcasts objectAtIndex:0] valueForKeyPath:@"vid"];
            success(broadcastId);
        } else {
            success(nil);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [operation start];
}

- (void)fetchLiveStreamUrlForBroadcastId:(NSString *)broadcastId sucess:(void(^)(NSURL *streamUrl))success failure:(void (^)(NSError *error))failure
{
    NSURL *broadcastUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json", BAMBUSER_TRANSCODE_URL, broadcastId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:broadcastUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *postParams = [NSString stringWithFormat:@"api_key=%@&preset=hls", BAMBUSER_TRANSCODE_API_KEY];
    [request setHTTPBody:[postParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSURL *streamUrl = [NSURL URLWithString:[[JSON valueForKeyPath:@"result"] valueForKeyPath:@"url"]];
        success(streamUrl);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"SlashatAPIManager: fetchLiveStreamUrlForBroadcastId: error: %@", error);
        failure(error);
    }];
    
    [operation start];
}


- (void)fetchNextSlashatCalendarItemWithSuccess:(void(^)(SlashatCalendarItem *calendarItem))success failure:(void(^)(NSError *error))failure
{
    NSString *parameterString = [NSString stringWithFormat:@"orderBy=startTime&singleEvents=true&timeMin=%@&key=%@", [DateUtils convertNSDateToGoogleCalendarString:[NSDate date]], GOOGLE_CALENDAR_API_KEY];
    
    NSString *encodedParameterString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)parameterString, NULL, CFSTR("+:"), kCFStringEncodingUTF8);
    
    NSString *calendarUrlString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/3om4bg9o7rdij1vuo7of48n910@group.calendar.google.com/events?%@", encodedParameterString];
    
    NSURL *calendarUrl = [NSURL URLWithString:calendarUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:calendarUrl];
    [request setHTTPMethod:@"GET"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSString *dateString = [[[(NSArray *)[JSON valueForKeyPath:@"items"] objectAtIndex:0] valueForKeyPath:@"start"] valueForKeyPath:@"dateTime"];
        
        SlashatCalendarItem *calendarItem = [[SlashatCalendarItem alloc] init];
        calendarItem.title = [[(NSArray *)[JSON valueForKeyPath:@"items"] objectAtIndex:0] valueForKeyPath:@"summary"];
        calendarItem.date = [DateUtils createNSDateFrom:dateString];
        
        success(calendarItem);
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
}

- (NSArray *)getSlashatHostsInSections
{
    NSString *plistHostPath = [[NSBundle mainBundle] pathForResource:@"Slashat-hosts" ofType:@"plist"];
    NSArray *plistRootArray = [[NSArray alloc] initWithContentsOfFile:plistHostPath];
    
    NSMutableArray *hostSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i < plistRootArray.count; i++) {
        
        NSArray *sectionHosts = [plistRootArray objectAtIndex:i][@"items"];
        
        NSMutableArray *hosts = [[NSMutableArray alloc] init];
        
        for (int j=0; j<sectionHosts.count; j++) {
            SlashatHost *host = [[SlashatHost alloc] init];
            host.name = [sectionHosts objectAtIndex:j][@"name"];
            host.profileImage = [UIImage imageNamed:[sectionHosts objectAtIndex:j][@"image"]];
            host.shortDescription = [sectionHosts objectAtIndex:j][@"short_description"];
            host.longDescription = [sectionHosts objectAtIndex:j][@"long_description"];
            host.twitterHandle = [sectionHosts objectAtIndex:j][@"twitter"];
            host.emailAdress = [sectionHosts objectAtIndex:j][@"mail"];
            host.link = [NSURL URLWithString:[sectionHosts objectAtIndex:j][@"web"]];
            [hosts addObject:host];
        }
        
        [hostSections addObject:hosts];
    }
    
    return hostSections;
}

- (NSArray *)getHostSectionTitles
{
    NSString *plistHostPath = [[NSBundle mainBundle] pathForResource:@"Slashat-hosts" ofType:@"plist"];
    NSArray *plistRootArray = [[NSArray alloc] initWithContentsOfFile:plistHostPath];
    
    NSMutableArray *sectionTitles = [[NSMutableArray alloc] init];
    for (int i = 0; i < plistRootArray.count; i++) {
        NSString *sectionTitle = [plistRootArray objectAtIndex:i][@"title"];
        [sectionTitles addObject:sectionTitle];
    }
    
    return sectionTitles;
}

- (void)loginHighFiveUserWithCredentials:(NSString *)userName password:(NSString *)password success:(void(^)(NSString *authToken))success failure:(void(^)(NSError *error))failure
{
    NSString *loginUrlString = [NSString stringWithFormat:@"%@login", SLASHAT_API_URL];
    
    NSURL *loginUrl = [NSURL URLWithString:loginUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@&deviceid=%@", userName, password, uuid];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([JSON valueForKey:@"token"] && [JSON valueForKey:@"token"] != [NSNull null]) {
            self.highFiveAuthToken = [JSON valueForKey:@"token"];
            success(self.highFiveAuthToken);
        } else {
            NSError *error = [[NSError alloc] initWithAttributes:JSON];
            failure(error);
        }
        
        NSLog(@"login success, token: %@", self.highFiveAuthToken);
        
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
}

- (void)fetchSlashatHighFiveUserWithSuccess:(void(^)(SlashatHighFiveUser *user))success failure:(void(^)(NSError *error))failure
{
    NSString *loginUrlString = [NSString stringWithFormat:@"%@getuser", SLASHAT_API_URL];
    
    NSURL *loginUrl = [NSURL URLWithString:loginUrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"token=%@", self.highFiveAuthToken];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        SlashatHighFiveUser *highFiveUser = [[SlashatHighFiveUser alloc] initWithAttributes:JSON];
        NSLog(@"getUser success: %@", highFiveUser.userName);
        if (highFiveUser.userName) {
            success(highFiveUser);
        }
        else {
            NSError *error = [[NSError alloc] initWithAttributes:JSON];
            failure(error);
        }
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
    
    
    
    
    
    /*SlashatHighFiveUser *user = [[SlashatHighFiveUser alloc] init];
    user.userName = @"kottkrig";
    user.qrCode = [NSURL URLWithString:@"http://api.qrserver.com/v1/create-qr-code/?data=Slashat%20rules&size=510x510"];
    user.profilePicture = [NSURL URLWithString:@"http://www.gravatar.com/avatar/a85e891db7a0bfd5e3ec12575559bece.png"];
    
    user.highFivers = [self getMockHighFiveUsers];
    success(user);*/
}

- (void)fetchAllSlashatHighFiversWithSuccess:(void(^)(NSArray *users))success failure:(void(^)(NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@getallusers", SLASHAT_API_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //NSString *params = [NSString stringWithFormat:@"token=%@", self.highFiveAuthToken];
    //[request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"allSlashatUsers success: %@", JSON);
        
        NSMutableArray *highFivers = [[NSMutableArray alloc] init];
        for (NSString *highFiverKey in JSON) {
            NSDictionary *highFiverAttributes = [JSON objectForKey:highFiverKey];
            [highFivers addObject:[[SlashatHighFiveUser alloc] initWithAttributes:highFiverAttributes]];
        }
        
        success(highFivers);
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"Failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
    
    
    //success([self getMockHighFiveUsers]);
}

- (NSArray *)getMockHighFiveUsers
{
    NSMutableArray *snyggJeppeArray = [NSMutableArray array];
    
    for (int i = 0; i < 180; i++) {
        SlashatHighFiveUser *highFiver = [[SlashatHighFiveUser alloc] init];
        highFiver.userName = @"jezper";
        highFiver.profilePicture = [NSURL URLWithString:@"http://forum.slashat.se/download/file.php?avatar=54_1371413866.png"];
        
        [snyggJeppeArray addObject:highFiver];
    }
    
    return snyggJeppeArray;
}

- (void)setHighFiveAuthToken:(NSString *)authToken
{
    _highFiveAuthToken = authToken;
    
    if (!self.tokenKeyChainItem) {
        self.tokenKeyChainItem = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"HighFiveToken" accessGroup:nil];
    }
    
    [self.tokenKeyChainItem setObject:authToken forKey:(__bridge id)kSecValueData];
}

- (NSString *)highFiveAuthToken
{
    if (!_highFiveAuthToken) {
        _highFiveAuthToken = [self getTokenFromKeyChain];
    }
    
    return _highFiveAuthToken;
}

- (NSString *)getTokenFromKeyChain
{
    if (!self.tokenKeyChainItem) {
        self.tokenKeyChainItem = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"HighFiveToken" accessGroup:nil];
    }
    
    return (NSString *)[self.tokenKeyChainItem objectForKey:(__bridge id)kSecValueData];
}

- (void)clearTokenFromKeychain
{
    if (!self.tokenKeyChainItem) {
        self.tokenKeyChainItem = [[KDJKeychainItemWrapper alloc] initWithIdentifier:@"HighFiveToken" accessGroup:nil];
    }
    
    [self.tokenKeyChainItem setObject:@"" forKey:(__bridge id)kSecValueData];
}

- (void)performSlashatHighFive:(SlashatHighFive *)highFive success:(void(^)())success failure:(void(^)(NSError *error))failure
{    
    NSString *hi5UrlString = [NSString stringWithFormat:@"%@sethi5", SLASHAT_API_URL];
    NSURL *url = [NSURL URLWithString:hi5UrlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *params = [NSString stringWithFormat:@"token=%@&receiver=%@&geolocation_lon=%f&geolocation_lat=%f", self.highFiveAuthToken, highFive.receiverToken, highFive.coordinate.longitude, highFive.coordinate.latitude];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([JSON valueForKey:@"success"] && [JSON valueForKey:@"success"] != [NSNull null]) {
            if (success) {
                success();
            }
        } else {
            failure([[NSError alloc]initWithAttributes:JSON]);
        }
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        NSLog(@"hi5 failed: %@",[error localizedDescription]);
    }];
    
    [operation start];
}


- (BOOL)userIsLoggedIn
{
    NSString *token = [self getTokenFromKeyChain];
    return token && token.length;
}

@end
