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
#import <QuartzCore/QuartzCore.h>
#import "DateUtils.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SlashatHighFiverCollectionHeaderView.h"
#import "SlashatAchievement.h"
#import "SlashatBadge.h"
#import "SlashatAchievementDetailViewController.h"


@interface SlashatHighFiveViewController ()

@property (strong, nonatomic) SlashatHighFiveUser *user;
@property (strong, nonatomic) NSArray *sections;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *highFiversCollectionView;

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *giveHighFiveButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) UIView *loginAlertViewUnderlayView;
@property (strong, nonatomic) UIAlertView *loginAlertView;

@property (weak, nonatomic) IBOutlet UILabel *noHighFivesDescriptionLabel;

@end

@implementation SlashatHighFiveViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        (void)[self.tabBarItem initWithTitle:@"High-Five!" image:[UIImage imageNamed:@"tab-bar_highfive_inactive.png"] selectedImage:[UIImage imageNamed:@"tab-bar_highfive_active.png"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[SlashatHighFiveUser logOutUser];
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.highFiversCollectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 20, 60, 20);
    
    self.highFiversCollectionView.delegate = self;
    
    self.nameLabel.text = @"";
    self.profileDescriptionLabel.text = @"";
    
    self.profileInfoView.layer.masksToBounds = NO;
    self.profileInfoView.layer.shadowOffset = CGSizeMake(0, 0);
    self.profileInfoView.layer.shadowRadius = 1;
    self.profileInfoView.layer.shadowOpacity = 0.5;
    
    if ([SlashatHighFiveUser userIsLoggedIn]) {
        [self initializeLocationManager];
    } else {
        [self addLoginAlertViewUnderlay];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == self.sections.count - 1) {
        return UIEdgeInsetsMake(5, 20, 120, 20);
    } else {
        return UIEdgeInsetsMake(5, 20, 20, 20);
    }
}

- (void)initializeLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    [self updateLocation];
}

- (void)updateLocation
{
    if (self.locationManager) {
        [self.locationManager startUpdatingLocation];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self activateView];    
}

- (void)applicationEnteredForeground:(NSNotification *)notification
{
    [self activateView];
}

- (void)activateView
{
    [self updateLocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL automaticLogin = [defaults boolForKey:@"highFiveAutomaticLogin"];
    
    if (!automaticLogin) {
        [SlashatHighFiveUser logOutUser];
    }
    
    if ([SlashatHighFiveUser userIsLoggedIn]) {
        NSLog(@"User is already logged in. Fetching user.");
        [SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
            [self updateViewWithUser:user];
        } onError:^(NSError *error) {
            [self showLoginView];
        }];
    }
    else if(self.tabBarController.selectedIndex == 3) {
        // Only show loginAlert when this tab is selected
        [self addLoginAlertViewUnderlay];
        [self showLoginView];
    }
}

- (void)showLoginView
{
    if (!self.loginAlertView) {
        self.loginAlertView = [[UIAlertView alloc] initWithTitle:nil message:Nil delegate:nil cancelButtonTitle:@"Avbryt" otherButtonTitles:NSLocalizedString(@"Logga in", @"Logga in-knapp i login-alertview"), NSLocalizedString(@"Skapa konto", @"Skapa konto-knapp i login-alertview"), nil];
    }
    
    self.loginAlertView.title = NSLocalizedString(@"Slashat.se Forum-konto:", @"Titel på login-alertview");
    self.loginAlertView.message = NSLocalizedString(@"Du använder ditt befintliga Slashat.se Forum-konto för\natt koppla ihop appen med\n din forumprofil.", @"Undertitel på login-alertview");
    self.loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    self.loginAlertView.delegate = self;
    [self.loginAlertView textFieldAtIndex:0].placeholder = @"Användarnamn";
    [self.loginAlertView show];
    
    [self addLoginAlertViewUnderlay];
}

- (void)addLoginAlertViewUnderlay
{
    if (!self.loginAlertViewUnderlayView) {
        CGRect underlayFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.loginAlertViewUnderlayView = [[UIView alloc] initWithFrame:underlayFrame];
        self.loginAlertViewUnderlayView.backgroundColor = [UIColor whiteColor];
    }
    
    if (!self.loginAlertViewUnderlayView.superview) {
        [self.view addSubview:self.loginAlertViewUnderlayView];
    }
}

- (void)removeLoginAlertViewUnderlay
{
    if (self.loginAlertViewUnderlayView && self.loginAlertViewUnderlayView.superview) {
        [self.loginAlertViewUnderlayView removeFromSuperview];
    }
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
        [self initializeLocationManager];
    } onError:^(NSError *error) {
        [self showLoginView];
    }];
}

- (void)updateViewWithUser:(SlashatHighFiveUser *)user
{
    [self removeLoginAlertViewUnderlay];
    
    self.user = user;
    
    [self updateSectionsWithDataFromUser:user];
    
    self.nameLabel.text = user.userName;
    [self.profileImageView setImageWithURL:user.profilePicture];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    self.profileDescriptionLabel.text = [NSString stringWithFormat:@"Fick sin första High-Five av %@ för %@.", self.user.highfivedByName, [DateUtils convertNSDateToFriendlyString:self.user.highfivedDate]];
    
    self.giveHighFiveButton.enabled = YES;
    
    if (user.highFivers.count > 0) {
        self.profileDescriptionLabel.hidden = NO;
        self.noHighFivesDescriptionLabel.hidden = YES;
        self.highFiversCollectionView.hidden = NO;
    } else {
        self.profileDescriptionLabel.hidden = YES;
        self.noHighFivesDescriptionLabel.hidden = NO;
        self.highFiversCollectionView.hidden = YES;
    }
    
    [self.highFiversCollectionView reloadData];
}

- (void)updateSectionsWithDataFromUser:(SlashatHighFiveUser *)user
{
    NSMutableArray *sections = [NSMutableArray array];
    
    if (user.badges.count > 0) {
        [sections addObject:@{
                              @"title": NSLocalizedString(@"Mina troféer:", @"Badges"),
                              @"items": user.badges
                              }];
    }
    
    if (user.achievements.count > 0) {
        [sections addObject:@{
                              @"title": NSLocalizedString(@"Mina bedrifter:", @"Achievements"),
                              @"items": user.achievements
                              }];
    }
    
    if (user.highFivers.count > 0) {
        [sections addObject:@{
                              @"title": [NSString stringWithFormat:@"Mina %u High-Fivers:", user.highFivers.count],
                              @"items": user.highFivers
                              }];
    }
    
    self.sections = sections;
}

- (void)enableGiveHighFiveButton
{
    self.giveHighFiveButton.enabled = YES;
    self.profileDescriptionLabel.hidden = NO;
    self.noHighFivesDescriptionLabel.hidden = YES;
    self.highFiversCollectionView.hidden = NO;
}

- (void)disableGiveHighFiveButton
{
    self.giveHighFiveButton.enabled = NO;
    self.profileDescriptionLabel.hidden = YES;
    self.noHighFivesDescriptionLabel.hidden = NO;
    self.highFiversCollectionView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReceiveHighFiveSegue"]) {
        SlashatReceiveHighFiveViewController *highFiveReceiverViewController = [((UINavigationController *)segue.destinationViewController).viewControllers objectAtIndex:0];
        highFiveReceiverViewController.highFiveUser = self.user;
    } else if ([segue.identifier isEqualToString:@"AchievementDetailSegue"]) {
        SlashatAchievementDetailViewController *achievementDetailViewController = segue.destinationViewController;
        
        NSIndexPath *selectedIndexPath = [[self.highFiversCollectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        
        id selectedItem = [[self.sections objectAtIndex:selectedIndexPath.section][@"items"] objectAtIndex:selectedIndexPath.row];
        
        if ([selectedItem isKindOfClass:[SlashatBadge class]]) {
            achievementDetailViewController.badge = selectedItem;
        } else if ([selectedItem isKindOfClass:[SlashatAchievement class]]) {
            achievementDetailViewController.achievement = selectedItem;
        } else if ([selectedItem isKindOfClass:[SlashatHighFiveUser class]]) {
            achievementDetailViewController.highFiveUser = selectedItem;
        }
    }
    
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

- (void)imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    for (ZBarSymbol *object in results) {
        NSLog(@"QR Result: '%@'", object.data);
        SlashatHighFive *highFive = [[SlashatHighFive alloc] init];
        highFive.receiverToken = object.data;
        highFive.coordinate = self.currentLocation.coordinate;
        
        [self performHighFive:highFive];
        break;
    }
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)performHighFive:(SlashatHighFive *)highFive
{
    [SlashatHighFive performHighFive:highFive success:^{
        NSLog(@"SlashatHighFiveViewController: High five success. Fetching new user data.");
        [self showHighFiveSuccessFeedback];
        [SlashatHighFiveUser fetchUserWithSuccess:^(SlashatHighFiveUser *user) {
            [self updateViewWithUser:user];
        } onError:nil];
    } failure:^(NSError *error) {
        [self showHighFiveErrorFeedback];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.user) {
        NSDictionary *sectionItem = [self.sections objectAtIndex:section];
        return ((NSArray *)sectionItem[@"items"]).count;
    } else {
        return 0;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 2) {
        return CGSizeMake(70, 70);
    } else {
        return CGSizeMake(70, 90);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HighFiverCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *highFiverImageView = (UIImageView *)[cell viewWithTag:100];
    highFiverImageView.alpha = 1.0f;
    highFiverImageView.layer.cornerRadius = 0;
    highFiverImageView.layer.masksToBounds = NO;
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = @"";
    
    NSDictionary *sectionItem = [self.sections objectAtIndex:indexPath.section];
    id item = [((NSArray *)sectionItem[@"items"]) objectAtIndex:indexPath.row];
    
    if ([item isKindOfClass:[SlashatBadge class]]) {
        [highFiverImageView setImageWithURL:((SlashatBadge *)item).imageUrl];
    } else if([item isKindOfClass:[SlashatAchievement class]]) {
        SlashatAchievement *achievement = (SlashatAchievement *)item;
        
        [highFiverImageView setImageWithURL:achievement.imageUrl];
        
        if (!achievement.achieved) {
            highFiverImageView.alpha = 0.2f;
            highFiverImageView.tintColor = [UIColor whiteColor];
            highFiverImageView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        }
    } else if([item isKindOfClass:[SlashatHighFiveUser class]]) {
        
        SlashatHighFiveUser *user = (SlashatHighFiveUser *)item;
        
        [highFiverImageView setImageWithURL:user.profilePicture];
        
        highFiverImageView.layer.cornerRadius = highFiverImageView.bounds.size.width / 2;
        highFiverImageView.layer.masksToBounds = YES;
        
        nameLabel.text = user.userName;
    }
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SlashatHighFiverCollectionHeaderView *header = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"HighFiverSection"
                                                           forIndexPath:indexPath];
        
        header.title.text = [self.sections objectAtIndex:indexPath.section][@"title"];
    }
    
    return header;
}

- (void)showHighFiveSuccessFeedback
{
    [self showHighFiveFeedback:NSLocalizedString(@"Yay, High-Five!", @"Feedback i notifikation när High-Five lyckades.") color:[UIColor highFiveFeedbackGoodTextColor]];
}

- (void)showHighFiveErrorFeedback
{
    [self showHighFiveFeedback:NSLocalizedString(@"Aj då, det där gick inte så bra. Försök igen!", @"Feedback i notifikation när High-Five misslyckades.") color:[UIColor highFiveFeedbackBadTextColor]];
}

- (void)showHighFiveFeedback:(NSString *)feedbackText color:(UIColor *)textColor;
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"HighFiveFeedbackView" owner:self options:nil];
    UIView *feedbackView = [subviewArray objectAtIndex:0];
    
    UILabel *feedbackTextLabel = (UILabel *)[feedbackView viewWithTag:1];
    feedbackTextLabel.text = feedbackText;
    feedbackTextLabel.textColor = textColor;
    
    CGRect frame = CGRectMake(0, self.profileInfoView.frame.origin.y + self.profileInfoView.frame.size.height - 25, self.profileInfoView.frame.size.width, 25);
    feedbackView.frame = frame;
    
    CGRect newFrame = CGRectMake(0, frame.origin.y + frame.size.height, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:0.25 animations:^{
        feedbackView.frame = newFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:3.0 options:nil animations:^{
            feedbackView.frame = frame;
        } completion:^(BOOL finished) {
            [feedbackView removeFromSuperview];
        }];
    }];
    
    [self.view addSubview:feedbackView];
    [self.view addSubview:self.profileInfoView];
}

@end
