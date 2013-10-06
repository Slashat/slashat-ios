//
//  SlashatHighFiveViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-09-28.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatHighFiveViewController.h"
#import "SlashatHighFiveUser+RemoteAccessors.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SlashatReceiveHighFiveViewController.h"
#import "SlashatHighFive+RemoteAccessors.h"

@interface SlashatHighFiveViewController ()

@property (strong, nonatomic) SlashatHighFiveUser *user;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *highFiversCollectionView;

@end

@implementation SlashatHighFiveViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"High Five!" image:nil tag:0];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab-bar_highfive_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab-bar_highfive_inactive.png"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*[SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
        [self updateViewWithUser:user];
    } onError:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];*/
    
    NSLog(@"User is loggedIn: %hhd", [SlashatHighFiveUser userIsLoggedIn]);
    [SlashatHighFiveUser loginWithCredentials:@"kottkrig" password:@"password" success:^(SlashatHighFiveUser *user) {
        NSLog(@"User is logged in after supplying credentials: %hhd", [SlashatHighFiveUser userIsLoggedIn]);
        [self updateViewWithUser:user];
    } onError:^(NSError *error) {
        
    }];
}

- (void)updateViewWithUser:(SlashatHighFiveUser *)user
{
    self.user = user;
    
    self.nameLabel.text = user.userName;
    [self.profileImageView setImageWithURL:user.profilePicture];
    
    [self.highFiversCollectionView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SlashatReceiveHighFiveViewController *highFiveReceiverViewController = [((UINavigationController *)segue.destinationViewController).viewControllers objectAtIndex:0];
    highFiveReceiverViewController.highFiveUser = self.user;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)giveHighFiveButtonPressed:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    reader.readerView.zoom = 1.0;
    
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    for (ZBarSymbol *object in results) {
        NSLog(@"QR Result: '%@'", object.data);
        SlashatHighFive *highFive = [[SlashatHighFive alloc] init];
        highFive.receiverToken = object.data;
        [SlashatHighFive performHighFive:highFive success:^{
            [SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
                [self updateViewWithUser:user];
            } onError:nil];
        } failure:nil];
        
        break;
    }
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.user) {
        return self.user.highFivers.count;
    } else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HighFiverCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *highFiverImageView = (UIImageView *)[cell viewWithTag:100];
    [highFiverImageView setImageWithURL:((SlashatHighFiveUser *)[self.user.highFivers objectAtIndex:indexPath.row]).profilePicture];
    
    return cell;
}

@end
