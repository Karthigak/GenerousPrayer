//
//  IndividualSignUpTwo.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CommonMethodClass.h"
#import "UILabel+changeAppearance.h"
#import "ViewController.h"
#import "IndividualSignUpTwo.h"
#import "IndividualSignUpThree.h"
@interface IndividualSignUpTwo : UIViewController<UITextFieldDelegate>
{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
}
@end
