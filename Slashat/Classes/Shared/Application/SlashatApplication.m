//
//  SlashatApplication.m
//  Slashat
//
//  Created by Johan Larsson on 2013-08-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatApplication.h"
#import "AppDelegate.h"

@implementation SlashatApplication

- (BOOL)openURL:(NSURL *)url
{
    if  ([((AppDelegate *)self.delegate) openURL:url])
        return YES;
    else
        return [super openURL:url];
}

- (void)openCustomURL:(NSURL *)url
{
    [super openURL:url];
}

@end
