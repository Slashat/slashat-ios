//
//  SlashatAboutTableViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-01-03.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatAboutTableViewController.h"
#import "SlashatAboutHostProfileViewController.h"
#import "SlashatHost.h"

@interface SlashatAboutTableViewController ()

@property (nonatomic, strong) NSArray *hosts;

@end

@implementation SlashatAboutTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hosts = [self getSlashatHostsFromPlist];
}

- (NSArray *)getSlashatHostsFromPlist
{
    NSString *plistHostPath = [[NSBundle mainBundle] pathForResource:@"Slashat-hosts" ofType:@"plist"];
    NSDictionary *hostsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistHostPath];
    NSArray *hostIds = [hostsDictionary allKeys];
    
    NSMutableArray *hosts = [[NSMutableArray alloc] init];
    
    for (int i=0; i < hostIds.count; i++) {
        SlashatHost *host = [[SlashatHost alloc] init];
        host.name = hostsDictionary[[hostIds objectAtIndex:i]][@"name"];
        host.description = hostsDictionary[[hostIds objectAtIndex:i]][@"description"];
        [hosts addObject:host];
    }
    
    return hosts;
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
    return self.hosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SlashatAboutTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = ((SlashatHost *)[self.hosts objectAtIndex:indexPath.row]).name;
    cell.detailTextLabel.text = ((SlashatHost *)[self.hosts objectAtIndex:indexPath.row]).description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SlashatAboutHostProfileSegway"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        SlashatHost *selectedHost = [self.hosts objectAtIndex:selectedIndexPath.row];
        ((SlashatAboutHostProfileViewController *)segue.destinationViewController).host = selectedHost;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
