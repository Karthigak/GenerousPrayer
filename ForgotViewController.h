//
//  ForgotViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CustomAFNetworking.h"
#import "Constants.h"
#import "CommonMethodClass.h"
#import "AFNetworking.h"

@interface ForgotViewController : UIViewController
{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    MBProgressHUD *HUD;

}
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *dob;

@end