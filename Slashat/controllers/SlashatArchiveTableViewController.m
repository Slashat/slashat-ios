//
//  SlashatArchiveTableViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatArchiveTableViewController.h"
#import "SlashatEpisode.h"
#import "RSSParser.h"
#import "SlashatArchiveEpisodeViewController.h"
#import "ColorUtils.h"

@interface SlashatArchiveTableViewController ()

@end

@implementation SlashatArchiveTableViewController

@synthesize allEntries = _allEntries;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl.tintColor = UIColorFromRGB(0xec3700);
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

    self.allEntries = [NSMutableArray array];
    [self refresh];
}

- (void) refresh {
    NSLog(@"Refreshing!");
    NSURL *url = [NSURL URLWithString:@"http://slashat.se/feed/podcast/slashat.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        NSLog(@"Refresh done!");
        [_allEntries addObjectsFromArray:feedItems];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SlashatArchiveTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SlashatEpisode *episode = [_allEntries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = episode.title;
    cell.detailTextLabel.text = episode.itemDescription;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];    
    SlashatArchiveEpisodeViewController *episodeViewController = segue.destinationViewController;
    [episodeViewController setEpisode:[_allEntries objectAtIndex:indexPath.row]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
