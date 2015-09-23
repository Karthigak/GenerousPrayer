//
//  OraganizationSignUpTwo.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OraganizationSignUpTwo : UIViewController<UITextFieldDelegate>{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    NSUserDefaults *defaults;

   
}


@end
