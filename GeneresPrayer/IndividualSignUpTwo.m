//
//  IndividualSignUpTwo.m
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import "IndividualSignUpTwo.h"
#import "IndividualSignUpOne.h"
@interface IndividualSignUpTwo ()
{
    NSUserDefaults *defaults;

}
@property (weak, nonatomic) IBOutlet UITextField *EmailText;
@property (weak, nonatomic) IBOutlet UITextField *MobileText;
- (IBAction)NextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;
- (IBAction)SignInView:(id)sender;
- (IBAction)Dots:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@end

@implementation IndividualSignUpTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    self.EmailText.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Email Address" color:[UIColor whiteColor]];
    self.MobileText.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Mobile Number" color:[UIColor whiteColor]];
    [self.buttonTwo setImage:[UIImage imageNamed:@"selecteddot.png"] forState:UIControlStateNormal];
    [self.MobileText setKeyboardType:UIKeyboardTypeNumberPad];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSString *nameRember=[defaults valueForKey:@"Email"];
    NSString *passRember=[defaults valueForKey:@"Mobile"];
    if ([CommonMethodClass isEmpty:nameRember] && [CommonMethodClass isEmpty:passRember] ){
        
    }else{
        self.EmailText.text=nameRember;
        self.MobileText.text=passRember;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)validate:(UIViewController *)goToViewController{
    if ([self.EmailText.text isEqualToString:@""]) {
        [self showAlert:@"Please enter your Email Address"];
    }else if ([self.MobileText.text isEqualToString:@""]){
        [self showAlert:@"Please enter your Mobile Number"];
    }else if (![CommonMethodClass validateEmail:self.EmailText.text]){
        [self showAlert:@"Please enter a valid Email Address"];
    }
    else{
        [defaults setObject:self.EmailText.text forKey:@"Email"];
        [defaults setObject:self.MobileText.text forKey:@"Mobile"];
        [self.navigationController pushViewController:goToViewController animated:YES];
    }
}
-(void)showAlert:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:cancelAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)NextAction:(id)sender {
    IndividualSignUpThree *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"IndividualSignUpThree"];
    [self validate:singUpOne];

}
- (IBAction)SignInView:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Are you sure want to cancel SIGN-UP?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    UIAlertAction *yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction *action)
                          {
                              
                              ViewController *VC=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                              [self.navigationController pushViewController:VC animated:YES];
                          }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:yes];
    
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)Dots:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.tag==0) {
        IndividualSignUpOne *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"IndividualSignUpOne"];
        [self.navigationController pushViewController:singUpOne animated:YES];

    }else if (button.tag==1){
           }
    else if (button.tag==2){
        IndividualSignUpThree *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"IndividualSignUpThree"];
        [self validate:singUpOne];
    }

}
#pragma keyboard delegates

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark :Scroll up the current screen position when keyboard appear
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIView *accView = [self createInputAccessoryView];
    [textField setInputAccessoryView:accView];
    
    return TRUE;
}

#pragma mark :Scroll up the current screen position when keyboard appear
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self doFramBoundUp:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self doFramBoundsDown];
}

-(void)doFramBoundUp :(UITextField *)textField{
    CGRect textFieldRect;
    activeField = textField;
    textFieldRect = [self.view convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) *viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0){
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }else{
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //        viewFrame.origin.x -= animatedDistance+25;
        if(IS_OS_8_OR_LATER){
            viewFrame.origin.y -= animatedDistance+25;
        }else{
            viewFrame.origin.x -= animatedDistance+25;
        }
    }else{
        viewFrame.origin.y -= animatedDistance;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)doFramBoundsDown{
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    
    CGRect viewFrame = self.view.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //viewFrame.origin.x += animatedDistance+25;
        if(IS_OS_8_OR_LATER){
            viewFrame.origin.y += animatedDistance+25;
        }else{
            viewFrame.origin.x += animatedDistance+25;
        }
    }else{
        viewFrame.origin.y += animatedDistance;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - keyboard
-(UIView*)createInputAccessoryView{
    UIButton *btnDone;
    UIView *inputAccView;
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 20.0)];
    [inputAccView setBackgroundColor:[UIColor clearColor]];
    //[inputAccView setAlpha: 0.0];
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [btnDone setFrame:CGRectMake(962.0,-36.0f, 90.0f, 70.0f)];
    }else if(IS_IPHONE_6_PLUS){
        [btnDone setFrame:CGRectMake(360.0,-36.0f, 90.0f, 60.0f)];
    }else if(IS_IPHONE_6){
        [btnDone setFrame:CGRectMake(315.0,-36.0f, 90.0f, 60.0f)];
    }else{
        [btnDone setFrame:CGRectMake(265.0,-36.0f, 80.0f, 60.0f)];
    }   UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"down.png"]];
    btnDone.backgroundColor = background;
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    return inputAccView;
}
-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [activeField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==self.MobileText){
        static const NSUInteger limit = 15; // we limit to 70 characters
        NSUInteger allowedLength = limit - [textField.text length] + range.length;
        if (string.length > allowedLength) {
            if (string.length > 1) {
                // get at least the part of the new string that fits
                NSString *limitedString = [string substringToIndex:allowedLength];
                NSMutableString *newString = [textField.text mutableCopy];
                [newString replaceCharactersInRange:range withString:limitedString];
                textField.text = newString;
            }
            return NO;
        } else {
            return YES;
        }
        
    }
    return YES;

}
@end
