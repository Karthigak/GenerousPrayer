//
//  OraganizationSignUpOne.h
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LGActionSheet.h"

@interface OraganizationSignUpOne : UIViewController<UITextFieldDelegate,LGActionSheetDelegate>{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    NSString *selectedDOB;
    BOOL isAged;
    NSUserDefaults *defaults;

}
@property (weak, nonatomic) IBOutlet UITextField *OrganizationNameText;
@property (weak, nonatomic) IBOutlet UITextField *FirstNameText;
@property (weak, nonatomic) IBOutlet UITextField *LastNameText;
@property (weak, nonatomic) IBOutlet UILabel *DOBLable;
- (IBAction)NextAction:(id)sender;
- (IBAction)Dots:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@end
