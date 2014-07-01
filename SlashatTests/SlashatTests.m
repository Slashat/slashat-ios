//
//  SlashatTests.m
//  SlashatTests
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatTests.h"
#import "SlashatHighFiveUser.h"

@interface SlashatTests ()

@property (strong, nonatomic) NSString *allHighFiversJsonString;

@end

@implementation SlashatTests

- (void)setUp
{
    [super setUp];
    self.allHighFiversJsonString = @"{\"1\":{\"username\":\"tommie\",\"user_id\":\"1\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=53_1379446237.png\"},\"2\":{\"username\":\"hi5\",\"user_id\":\"2\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=4025_1380473073.jpg\"},\"3\":{\"username\":\"slashattester\",\"user_id\":\"3\",\"picture\":\"http://forum.slashat.se//download/file.php?avatar=4025_1380473073.jpg\"},\"4\":{\"username\":\"Smiley\",\"user_id\":\"4\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=1197_1372799107.jpg\"},\"5\":{\"username\":\"kottkrig\",\"user_id\":\"5\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=78_1382378593.jpeg\"},\"6\":{\"username\":\"jezper\",\"user_id\":\"6\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=54_1371413866.png\"},\"7\":{\"username\":\"Jonasson\",\"user_id\":\"7\",\"picture\":\"http://forum.slashat.se/download/file.php?avatar=66_1368392108.jpg\"},\"8\":{\"username\":\"riske\",\"user_id\":\"8\",\"picture\":\"http://forum.slashat.se//download/file.php?avatar=4025_1380473073.jpg\"},\"9\":{\"username\":\"Kotten2\",\"user_id\":\"9\",\"picture\":\"http://forum.slashat.se//download/file.php?avatar=4025_1380473073.jpg\"}}";
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testHighFiveInstantiationWithNoHighFivers
{
    NSString *jsonString = @"{ \"highfived_by_name\": null, \"highfived_date\": null, \"highfived_where\": null, \"highfivers\": {}, \"picture\": \"http://forum.slashat.se/download/file.php?avatar=78_1382378593.jpeg\", \"qrcode\": \"https://chart.googleapis.com/chart?chs=480x480&cht=qr&choe=UTF-8&chl=5\", \"user_id\": 5, \"username\": \"kottkrig\" }";
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    SlashatHighFiveUser *highFiveUser = [[SlashatHighFiveUser alloc] initWithAttributes:json];
    XCTAssertEqualObjects(highFiveUser.userName, @"kottkrig", @"Username should be kottkrig");
    XCTAssertEqual(highFiveUser.userId, 5, @"UserId should be 5");
    XCTAssertTrue(highFiveUser.highFivers.count == 0, @"There should be no highfivers");
}

- (void)testParseGetAllHighFivers
{
    NSData *jsonData = [self.allHighFiversJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *highFivers = [SlashatHighFiveUser initUsersSortedByUserIdWithAttributes:JSON];
    XCTAssertTrue(highFivers.count == 9, @"There should be 9 users in json data");
}

- (void)testHighFiversAreInAscendingOrder
{
    NSData *jsonData = [self.allHighFiversJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *highFivers = [SlashatHighFiveUser initUsersSortedByUserIdWithAttributes:JSON];
    
    BOOL ascendingOrder = YES;
    NSUInteger previousId = 0;
    for (NSUInteger i = 0; i < highFivers.count; i++) {
        SlashatHighFiveUser *highFiver = [highFivers objectAtIndex:i];
        if (highFiver.userId <= previousId) {
            ascendingOrder = NO;
            break;
        }
        previousId = highFiver.userId;
    }
    
    XCTAssertTrue(ascendingOrder, @"HighFivers should be in ascending order");
}

@end
