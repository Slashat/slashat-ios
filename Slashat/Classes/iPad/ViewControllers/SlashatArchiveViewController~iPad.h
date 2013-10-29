//
//  SlashatArchiveViewController~iPad.h
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlashatArchiveViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

- (id)initWithFrame:(CGRect)frame;

@end
