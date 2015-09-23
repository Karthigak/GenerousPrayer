//
//  EditProfileViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
@interface EditProfileViewController : UIViewController
{
    HMSegmentedControl *tabBar ;
    HMSegmentedControl *headerBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    IBOutlet UIImageView *profileImage;
    __weak IBOutlet UITextField *email;
    __weak IBOutlet UITextField *mobile;
    __weak IBOutlet UITextField *country;
    __weak IBOutlet UITextField *address1;
    __weak IBOutlet UITextField *address2;
    __weak IBOutlet UITextField *state;
    __weak IBOutlet UITextField *city;
    __weak IBOutlet UITextField *zipcode;

}
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;

@property (weak, nonatomic) IBOutlet UILabel *topShadowLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topBar;

- (IBAction)countryList:(id)sender;
- (IBAction)stateList:(id)sender;
- (IBAction)cityList:(id)sender;


@end
