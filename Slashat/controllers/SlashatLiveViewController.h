//
//  FirstViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlashatLiveViewController : UIViewController {
    IBOutlet UIWebView *embedWebView;
}

@property (nonatomic, retain) IBOutlet UIWebView *embedWebView; 

@end
