//
//  OraganizationSignUpFour.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "CommonMethodClass.h"
#import "MBProgressHUD.h"
#import "UILabel+changeAppearance.h"
#import "ViewController.h"

@interface OraganizationSignUpFour : UIViewController<UITextFieldDelegate>{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    NSString *isTermsValidate;
    NSMutableDictionary *postData;
    NSDictionary *passData;
    MBProgressHUD *HUD;
    NSUserDefaults *defaults;
}

@end
