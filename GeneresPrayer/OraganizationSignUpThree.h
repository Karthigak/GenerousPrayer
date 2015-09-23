//
//  OraganizationSignUpThree.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface OraganizationSignUpThree : UIViewController<UITextFieldDelegate,NIDropDownDelegate>{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    
    //drop downs
    NIDropDown *dropDown;
    CGFloat height;
    int selectedIndex;
    NSString *cityIdPost;
    NSString *stateIdPost;
    NSString *countryIdPost;
    NSString *CheckStringToPostId;
    BOOL isChecked;
    BOOL isCountry;
    BOOL isState;
    BOOL isCity;
}

@property(strong,nonatomic)NSMutableArray *datasList;
@property(strong,nonatomic)NSMutableArray *valuesList;

@property(strong,nonatomic)NSMutableArray *stateList;
@property(strong,nonatomic)NSMutableArray *cityList;
@end
