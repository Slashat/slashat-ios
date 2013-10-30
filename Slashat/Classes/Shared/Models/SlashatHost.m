//
//  SlashatHost.m
//  Slashat
//
//  Created by Johan Larsson on 2013-06-25.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHost.h"

@implementation SlashatHost

+ (NSArray *)getSlashatHostsInSections
{
    NSString *plistHostPath = [[NSBundle mainBundle] pathForResource:@"Slashat-hosts" ofType:@"plist"];
    NSArray *plistRootArray = [[NSArray alloc] initWithContentsOfFile:plistHostPath];
    
    NSMutableArray *hostSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i < plistRootArray.count; i++) {
        
        NSArray *sectionHosts = [plistRootArray objectAtIndex:i][@"items"];
        
        NSMutableArray *hosts = [[NSMutableArray alloc] init];
        
        for (int j=0; j<sectionHosts.count; j++) {
            NSString *imageName = [[sectionHosts objectAtIndex:j][@"image"] stringByDeletingPathExtension];
            NSString *imageExtension = [[sectionHosts objectAtIndex:j][@"image"] pathExtension];
            
            SlashatHost *host = [[SlashatHost alloc] init];
            host.name = [sectionHosts objectAtIndex:j][@"name"];
            host.profileImageName = [NSString stringWithFormat:@"%@.%@", imageName, imageExtension];
            //[[NSBundle mainBundle] pathForResource:imageName ofType:imageExtension];
            host.profileThumbnailImageName = [NSString stringWithFormat:@"%@_88x88.%@", imageName, imageExtension];
            
            //[[NSBundle mainBundle] pathForResource:[imageName stringByAppendingString:@"_88x88"] ofType:imageExtension];
            NSLog(@"host.profileThumbnailImagePath: %@.%@", [imageName stringByAppendingString:@"_88x88"], imageExtension);
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

+ (NSArray *)getHostSectionTitles
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

@end
