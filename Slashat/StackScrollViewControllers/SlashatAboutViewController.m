//
//  SlashatAboutViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-01.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAboutViewController.h"
#import "SlashatAPIManager.h"
#import "SlashatHost.h"
#import "SlashatAboutHostViewController~iPad.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"

@interface SlashatAboutViewController ()

@property (nonatomic, strong) NSArray *hosts;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SlashatAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
		[self.view setFrame:frame];
        
		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
        
        UIView* footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
		self.tableView.tableFooterView = footerView;
        
		[self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
		[self.view addSubview:self.tableView];
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.hosts = [[SlashatAPIManager sharedClient] getSlashatHostsInSections];
    self.sectionTitles = [[SlashatAPIManager sharedClient] getHostSectionTitles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.hosts.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ((NSArray *)[self.hosts objectAtIndex:section]).count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SlashatAboutTableViewCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SlashatHost *host = [[self.hosts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [cell.imageView setImage:host.profileImage];
    cell.textLabel.text = host.name;
    cell.detailTextLabel.text = host.shortDescription;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlashatAboutHostViewController_iPad *aboutHostViewController = [[SlashatAboutHostViewController_iPad alloc] initWithNibName:@"SlashatAboutHostView~iPad" bundle:nil];
    
    
    aboutHostViewController.host = [[self.hosts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
	[((RootViewController *)[AppDelegate sharedAppDelegate].window.rootViewController).stackScrollViewController addViewInSlider:aboutHostViewController invokeByController:self isStackStartView:FALSE];
    
    aboutHostViewController.view.frame = CGRectMake(0, 0, 477, self.view.frame.size.height);
}

@end
