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
#import "SlashatHighFiveUser+RemoteAccessors.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SlashatAboutTableViewController ()

@property (nonatomic, strong) NSArray *hosts;
@property (nonatomic, strong) NSArray *sectionNames;

@property (nonatomic, strong) NSArray *highFivers;

@end

@implementation SlashatAboutTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        (void)[self.tabBarItem initWithTitle:@"Om Slashat.se" image:[UIImage imageNamed:@"tab-bar_about_inactive.png"] selectedImage:[UIImage imageNamed:@"tab-bar_about_active.png"]];
    }
    
    return self;
}

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
    
    //UIColor *darkSeparatorColor = [UIColor colorWithRed:46/255.0f green:45/255.0f blue:48/255.0f alpha:1];
    //[[UITableViewHeaderFooterView appearance] setTintColor:darkSeparatorColor];
    
    self.hosts = [SlashatHost getSlashatHostsInSections];
    self.sectionNames = [SlashatHost getHostSectionTitles];
    [self.tableView reloadData];
    
    [SlashatHighFiveUser fetchAllHighFivers:^(NSArray *highFivers) {
        self.highFivers = highFivers;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        
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
    return self.hosts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 4) {
        return ((NSArray *)[self.hosts objectAtIndex:section]).count;
    } else if (self.highFivers) {
        return self.highFivers.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SlashatAboutTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section < 4) {
        SlashatHost *host = [[self.hosts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [cell.imageView setImage:[UIImage imageNamed:host.profileThumbnailImageName]];
        cell.textLabel.text = host.name;
        cell.detailTextLabel.text = host.shortDescription;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
    } else if (self.highFivers) {
        SlashatHighFiveUser *highFiver = (SlashatHighFiveUser *)[self.highFivers objectAtIndex:indexPath.row];
        cell.textLabel.text = highFiver.userName;
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        
        [cell.imageView setImageWithURL:highFiver.profilePicture placeholderImage:[UIImage imageNamed:@"about_table_view_placeholder.png"]];
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionNames objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"SlashatAboutTableViewController prepareForSegue");
    if ([segue.identifier isEqualToString:@"SlashatAboutHostProfileSegue"]) {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        SlashatHost *selectedHost = [[self.hosts objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];

        ((SlashatAboutHostProfileViewController *)segue.destinationViewController).host = selectedHost;
        NSLog(@"SlashatAboutTableViewController prepareForSegue: host has been set");
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
