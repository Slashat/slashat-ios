//
//  SlashatArchiveTableViewController.h
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlashatArchiveTableViewController : UITableViewController {
}

- (IBAction) subscribeButtonPressed:(id)sender;

@property (nonatomic, strong) NSArray *allEntries;

@end
