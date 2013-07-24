//
//  SlashatArchiveTableViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlashatArchiveTableViewController : UITableViewController {
    NSMutableArray *_allEntries;
}

- (IBAction) subscribeButtonPressed:(id)sender;

@property (retain) NSMutableArray *allEntries;

@end
