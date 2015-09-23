//
//  MyProfileViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface MyProfileViewController : UIViewController
{
    HMSegmentedControl *tabBar ;
    HMSegmentedControl *headerBar ;
    CGFloat viewWidth;
    CGFloat viewHeight;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *country;
    __weak IBOutlet UILabel *email;
    __weak IBOutlet UILabel *phonenumber;
    IBOutlet UIImageView *profileImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;

@property (weak, nonatomic) IBOutlet UILabel *topShadowLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topBar;
@end
