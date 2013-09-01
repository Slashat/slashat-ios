//
//  SlashatArchiveViewController~iPad.m
//  Slashat
//
//  Created by Johan Larsson on 2013-08-31.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatArchiveViewController~iPad.h"
#import "SlashatArchiveEpisodeViewController~iPad.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "SlashatAPIManager.h"
#import "SlashatEpisode.h"

@interface SlashatArchiveViewController_iPad ()

@property (nonatomic, strong) NSArray *episodes;

@end

@implementation SlashatArchiveViewController_iPad

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
	// Do any additional setup after loading the view.
    
    self.episodes = [NSArray array];
    [self refresh];
}

- (void) refresh {
    
    [[SlashatAPIManager sharedClient] fetchArchiveEpisodesWithSuccess:^(NSArray *episodes) {
        self.episodes = episodes;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"SlashatArchiveViewController~iPad: refresh: Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.episodes.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SlashatArchiveTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    SlashatEpisode *episode = [self.episodes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i - %@", episode.episodeNumber, episode.title];
    cell.detailTextLabel.text = episode.itemDescription;
    
    cell.selectedBackgroundView.backgroundColor = [UIColor slashatOrange];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SlashatArchiveEpisodeViewController_iPad *episodeViewController = [[SlashatArchiveEpisodeViewController_iPad alloc] initWithFrame:CGRectMake(0, 0, 477, self.view.frame.size.height)];
    
    SlashatArchiveEpisodeViewController_iPad *episodeViewController = [[SlashatArchiveEpisodeViewController_iPad alloc] initWithNibName:@"SlashatEpisodeView~iPad" bundle:nil];
    
    
    episodeViewController.episode = [self.episodes objectAtIndex:indexPath.row];
    
	[((RootViewController *)[AppDelegate sharedAppDelegate].window.rootViewController).stackScrollViewController addViewInSlider:episodeViewController invokeByController:self isStackStartView:FALSE];
    
    episodeViewController.view.frame = CGRectMake(0, 0, 477, self.view.frame.size.height);
}

@end
