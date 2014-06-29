//
//  SlashatAchievementDetailViewController.m
//  Slashat
//
//  Created by Johan Larsson on 2014-06-29.
//  Copyright (c) 2014 Johan Larsson. All rights reserved.
//

#import "SlashatAchievementDetailViewController.h"
#import "SlashatAchievement.h"
#import "SlashatBadge.h"
#import "SlashathighFiveUser.h"
#import "UIImageView+AFNetworking.h"

@interface SlashatAchievementDetailViewController()

@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation SlashatAchievementDetailViewController

- (void)viewDidLoad
{
    NSLog(@"SlashatAchievementDetailViewController: viewDidLoad: Calling [super viewDidLoad]");
    [super viewDidLoad];
    
    if (self.achievement) {
        self.descriptionTextView.text = self.achievement.achieved ? self.achievement.achievedDescription : self.achievement.description;
        [self.imageView setImageWithURL:self.achievement.largeImageUrl];
    }
    
    if (self.badge) {
        self.descriptionTextView.text = self.badge.description;
        [self.imageView setImageWithURL:self.badge.largeImageUrl];
    }
    
    if (self.highFiveUser) {
        self.descriptionTextView.text = self.highFiveUser.userName;
        [self.imageView setImageWithURL:self.highFiveUser.profilePicture];
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = self.imageView.bounds.size.width / 2;
    }
    
    
}

@end
