//
//  SlashatTests.m
//  SlashatTests
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatTests.h"
#import "SlashatHighFiveUser.h"

@implementation SlashatTests

- (void)setUp
{
    [super setUp];
    
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
    STAssertEqualObjects(highFiveUser.userName, @"kottkrig", @"Username should be kottkrig");
}

@end
