//
//  PrayerTimerViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 18/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
@interface PrayerTimerViewController : UIViewController
{
    HMSegmentedControl *tabBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@property (strong, nonatomic) IBOutlet UIButton *butotnTotalTimer;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
- (IBAction)Allaction:(id)sender;
- (IBAction)switchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *anonButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIButton *mineButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UISwitch *swithcOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwo;
@property (weak, nonatomic) IBOutlet UIButton *urgntButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

@end
