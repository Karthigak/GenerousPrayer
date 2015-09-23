//
//  IndividualSignUpOne.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LGActionSheet.h"
@interface IndividualSignUpOne : UIViewController<LGActionSheetDelegate,UITextFieldDelegate>
{
    
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    
}
@end
