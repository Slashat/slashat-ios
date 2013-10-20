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

@property (weak, nonatomic) IBOutlet UIButton *giveHighFiveButton;

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
    
    //[SlashatHighFiveUser logOutUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    NSLog(@"Application Entered Foreground");
    if ([SlashatHighFiveUser userIsLoggedIn]) {
        NSLog(@"User is already logged in. Fetching user.");
        [SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
            [self updateViewWithUser:user];
        } onError:^(NSError *error) {
            
        }];
    }
    else {
        [self showLoginView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([SlashatHighFiveUser userIsLoggedIn]) {
        NSLog(@"User is already logged in. Fetching user.");
        [SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
            [self updateViewWithUser:user];
        } onError:^(NSError *error) {
            
        }];
    }
    else {
        [self showLoginView];
    }
}

- (void)showLoginView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Nil delegate:nil cancelButtonTitle:@"Avbryt" otherButtonTitles:@"Logga in", @"Skapa konto", nil];
    alertView.title = @"Logga in";
    alertView.message = @"Använd de kontouppgifter som du använder för forum.slashat.se.";
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alertView.delegate = self;
    [alertView show];
}
    
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        
    } else if (buttonIndex == 1) {
        [self loginWithCredentials:[alertView textFieldAtIndex:0].text password:[alertView textFieldAtIndex:1].text];
    } else if (buttonIndex == 2) {
        // Användare vill registrera konto
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://forum.slashat.se/ucp.php?mode=register"]];
    }
}

- (void)loginWithCredentials:(NSString *)userName password:(NSString *)password
{
    [SlashatHighFiveUser loginWithCredentials:userName password:password success:^(SlashatHighFiveUser *user) {
        [self updateViewWithUser:user];
    } onError:^(NSError *error) {
        [self showLoginView];
    }];
}

- (void)updateViewWithUser:(SlashatHighFiveUser *)user
{
    self.user = user;
    
    self.nameLabel.text = user.userName;
    [self.profileImageView setImageWithURL:user.profilePicture];
    
    if (user.highFivers.count > 0) {
        self.giveHighFiveButton.enabled = TRUE;
    }
    
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
            NSLog(@"SlashatHighFiveViewController: High five success. Fetching new user data.");
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
