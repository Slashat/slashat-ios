//
//  SlashatReceiveHighFiveViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2013-10-06.
//  Copyright (c) 2013 Johan Larsson. All rights reserved.
//

#import "SlashatReceiveHighFiveViewController.h"
#import "SlashatHighFiveUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SlashatHighFive+RemoteAccessors.h"

@interface SlashatReceiveHighFiveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UITextView *instructionText;

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSString *previousResult;

@end

@implementation SlashatReceiveHighFiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    [self.qrCodeImageView setImageWithURL:self.highFiveUser.qrCode];
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    //self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    
    self.navigationItem.title = [NSString stringWithFormat:@"High-Five %@!", self.highFiveUser.userName];
	// Do any additional setup after loading the view.
    
    [self.view bringSubviewToFront:self.qrCodeImageView];
    [self.view bringSubviewToFront:self.instructionText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.capture.delegate = self;
    self.capture.layer.frame = self.view.bounds;
    
    CGAffineTransform captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
    self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
}

- (void)applicationEnteredForeground:(NSNotification *)notification
{
    [self updateLocation];
}


#pragma mark - Location

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


#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    if (![result.text isEqualToString:self.previousResult]) {
        self.previousResult = result.text;
        
        SlashatHighFive *highFive = [[SlashatHighFive alloc] init];
        highFive.receiverToken = result.text;
        highFive.coordinate = self.currentLocation.coordinate;
        
        [self performHighFive:highFive];
        
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - High-Five!


- (void)performHighFive:(SlashatHighFive *)highFive
{
    [SlashatHighFive performHighFive:highFive success:^{
        [self showHighFiveSuccessFeedback];
    } failure:^(NSError *error) {
        [self showHighFiveErrorFeedback];
    }];
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
    
    CGFloat frameHeight = 25;
    
    CGRect frame = CGRectMake(0, 0 - frameHeight, self.navigationController.navigationBar.frame.size.width, frameHeight);
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
}

#pragma mark - Memory stuff

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self.capture stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
