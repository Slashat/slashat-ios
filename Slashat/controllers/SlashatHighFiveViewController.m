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


@interface SlashatHighFiveViewController ()

@property (strong, nonatomic) SlashatHighFiveUser *user;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *highFiversCollectionView;

@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UILabel *profileDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *giveHighFiveButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) UIView *loginAlertViewUnderlayView;

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
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 20, 120, 20);
    
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
    
    if (arc4random_uniform(2) == 1) {
        [self showHighFiveSuccessFeedback];
    } else {
        [self showHighFiveErrorFeedback];
    }
    
    
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
    else {
        [self addLoginAlertViewUnderlay];
        [self showLoginView];
    }
}

- (void)showLoginView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Nil delegate:nil cancelButtonTitle:@"Avbryt" otherButtonTitles:@"Logga in", @"Skapa konto", nil];
    alertView.title = @"Slashat.se Forum-konto:";
    alertView.message = @"Du använder ditt befintliga Slashat.se Forum-konto för\natt koppla ihop appen med\n din forumprofil.";
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alertView.delegate = self;
    [alertView textFieldAtIndex:0].placeholder = @"Användarnamn";
    [alertView show];
    
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
    
    self.nameLabel.text = user.userName;
    [self.profileImageView setImageWithURL:user.profilePicture];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    self.profileDescriptionLabel.text = [NSString stringWithFormat:@"Fick sin första High-Five av %@ för %@.", self.user.highfivedByName, [DateUtils convertNSDateToFriendlyString:self.user.highfivedDate]];
    
    if (user.highFivers.count > 0) {
        self.giveHighFiveButton.enabled = YES;
        self.profileDescriptionLabel.hidden = NO;
    } else {
        self.giveHighFiveButton.enabled = NO;
        self.profileDescriptionLabel.hidden = YES;
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
        highFive.coordinate = self.currentLocation.coordinate;
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
    
    highFiverImageView.layer.cornerRadius = highFiverImageView.bounds.size.width / 2;
    highFiverImageView.layer.masksToBounds = YES;
    

    UILabel *nameLabel = (UILabel *)[cell viewWithTag:200];
    nameLabel.text = ((SlashatHighFiveUser *)[self.user.highFivers objectAtIndex:indexPath.row]).userName;
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"HighFiverSection"
                                                           forIndexPath:indexPath];
    }
    return header;
}

- (void)showHighFiveSuccessFeedback
{
    [self showHighFiveFeedback:@"High-Fiven gick bra!" color:[UIColor highFiveFeedbackGoodTextColor]];
}

- (void)showHighFiveErrorFeedback
{
    [self showHighFiveFeedback:@"High-Fiven gick dåligt! Försök igen!" color:[UIColor highFiveFeedbackBadTextColor]];
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
