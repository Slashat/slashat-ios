//
//  RSSParser.m
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSSParser.h"

@implementation RSSParser

#pragma mark lifecycle
- (id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
}

#pragma mark -

#pragma mark parser

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems))success
                       failure:(void (^)(NSError *error))failure
{
    RSSParser *parser = [[RSSParser alloc] init];
    [parser parseRSSFeedForRequest:urlRequest success:success failure:failure];
}


- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                                          success:(void (^)(NSArray *feedItems))success
                                          failure:(void (^)(NSError *error))failure
{
    
    block = [success copy];
    
    AFXMLRequestOperation *operation = [RSSParser XMLParserRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        [XMLParser setDelegate:self];
        [XMLParser parse];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParse) {
        failure(error);
    }];
    [operation start];
}

#pragma mark -

#pragma mark AFNetworking AFXMLRequestOperation acceptable Content-Type overwriting

+ (NSSet *)defaultAcceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml",@"application/rss+xml", nil];
}
+ (NSSet *)acceptableContentTypes {
    return [self defaultAcceptableContentTypes];
}
#pragma mark -

#pragma mark NSXMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"item"]) {
        currentItem = [[SlashatEpisode alloc] init];
    }
    
    tmpString = [[NSMutableString alloc] init];
    
    if ([elementName isEqualToString:@"enclosure"]) {
        NSString *urlString = [attributeDict objectForKey:@"url"];
        [currentItem setMediaUrl:[NSURL URLWithString:urlString]];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{    
    if ([elementName isEqualToString:@"item"]) {
        [items addObject:currentItem];
    }
    if (currentItem != nil && tmpString != nil) {
        
        if ([elementName isEqualToString:@"title"]) {
            [currentItem setTitle:[tmpString stringByReplacingOccurrencesOfString:@"Slashat.se #" withString:@""]];
            NSInteger episodeNumber;
            [[NSScanner scannerWithString:currentItem.title] scanInteger:&episodeNumber];
            currentItem.episodeNumber = [NSNumber numberWithInteger:episodeNumber];
            
            [currentItem setTitle:[currentItem.title stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ - ", currentItem.episodeNumber] withString:@""]];
        }
        
        if ([elementName isEqualToString:@"itunes:subtitle"]) {
            [currentItem setItemDescription:tmpString];
        }
        
        if ([elementName isEqualToString:@"itunes:summary"]) {
            [currentItem setShowNotes:tmpString];
        }
        
        if ([elementName isEqualToString:@"link"]) {
            [currentItem setLink:[NSURL URLWithString:tmpString]];
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [formatter setLocale:local];
            
            [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            
            [currentItem setPubDate:[formatter dateFromString:tmpString]];
            
        }
        
        if ([elementName isEqualToString:@"guid"]) {
            [currentItem setGuid:tmpString];
        }
        
    }
    
    if ([elementName isEqualToString:@"rss"]) {
        block(items);
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [tmpString appendString:string];
    
}

#pragma mark -

@end
