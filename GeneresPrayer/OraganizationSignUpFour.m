//
//  OraganizationSignUpFour.m
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import "OraganizationSignUpFour.h"
#import "OraganizationSignUpOne.h"
#import "OraganizationSignUpTwo.h"
#import "OraganizationSignUpThree.h"
#import "TermsAndConditionViewController.h"
#import "ActivationViewController.h"
@interface OraganizationSignUpFour (){
    
}
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPasswordText;
@property (weak, nonatomic) IBOutlet UILabel *termsLable;
- (IBAction)RegisterComplete:(id)sender;
- (IBAction)SignInView:(id)sender;
- (IBAction)Dots:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;

@end

@implementation OraganizationSignUpFour

-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    postData=[NSMutableDictionary dictionary];
    defaults=[NSUserDefaults standardUserDefaults];
    self.PasswordText.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Password" color:[UIColor whiteColor]];
    self.ConfirmPasswordText.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Confirm Password" color:[UIColor whiteColor]];
    [self.buttonFour setImage:[UIImage imageNamed:@"selecteddot.png"] forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getstureAnonmous)];
    tapGesture.numberOfTapsRequired=1;
    self.termsLable.userInteractionEnabled=YES;
    [self.termsLable addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
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
- (IBAction)RegisterComplete:(id)sender{
    if ([self.PasswordText.text isEqualToString:@""]) {
        [self showAlert:@"Please enter your Password"];
    }else if ([self.ConfirmPasswordText.text isEqualToString:@""]){
        [self showAlert:@"Please enter your Confirm Password"];
    }else if (![self.PasswordText.text isEqualToString:self.ConfirmPasswordText.text]){
        [self showAlert:@"Password you have entered was mismatched"];
    }else if ([self.PasswordText.text length]<6){
        [self showAlert:@"Password length should be maximum 6 in character"];
    }else if ([isTermsValidate isEqualToString:@"1"] || [CommonMethodClass isEmpty:isTermsValidate]){
        [self showAlert:@"Please agree to our Terms & Conditions"];
    }
    else{
        [postData setObject:self.PasswordText.text forKey:@"password"];
        [postData setObject:self.ConfirmPasswordText.text forKey:@"password_confirmation"];
        [postData setObject:[defaults valueForKey:@"FirstNameORG"] forKey:@"first_name"];
        [postData setObject:[defaults valueForKey:@"LastNameORG"] forKey:@"last_name"];
        [postData setObject:[defaults valueForKey:@"EmailORG"] forKey:@"email"];
        [postData setObject:[defaults valueForKey:@"MobileORG"] forKey:@"mobile"];
        [postData setObject:[defaults valueForKey:@"DOBORG"] forKey:@"dob"];
        [postData setObject:@"1" forKey:@"user_type"];
        [postData setObject:[defaults valueForKey:@"City"] forKey:@"city_id"];
        [postData setObject:[defaults valueForKey:@"State"] forKey:@"state_id"];
        [postData setObject:[defaults valueForKey:@"Country"] forKey:@"country_id"];
        [postData setObject:[defaults valueForKey:@"AddressOne"] forKey:@"address_1"];
        [postData setObject:[defaults valueForKey:@"AddressTwo"] forKey:@"address_2"];
        [postData setObject:[defaults valueForKey:@"ZipCode"] forKey:@"pincode"];
        passData = @{@"user":postData};
        NSLog(@"%@",passData);
        [self HUDAction];
        NSMutableURLRequest*   request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/users/register" dictornay:passData];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"------->hgfkjfhg%@",responseObject);
            [HUD hide:YES];
            NSDictionary *json=(NSDictionary *)responseObject;
            NSDictionary *dict=[json valueForKey:@"data"];
            NSString *activateCode=[dict valueForKey:@"activation_code"];
            NSString *status=[NSString stringWithFormat:@"%@",[json valueForKey:@"status"]];
            NSString *errorStatus=[NSString stringWithFormat:@"%@",[json valueForKey:@"error_code"]];
            if([status isEqualToString:@"200"]){
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:[json valueForKey:@"message"]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   [defaults removeObjectForKey:@"Country"];
                                                   [defaults removeObjectForKey:@"City"];
                                                   [defaults removeObjectForKey:@"State"];
                                                   [defaults removeObjectForKey:@"ZipCode"];
                                                   [defaults removeObjectForKey:@"AddressOne"];
                                                   [defaults removeObjectForKey:@"AddressTwo"];

                                                   [defaults removeObjectForKey:@"FirstNameORG"];
                                                   [defaults removeObjectForKey:@"LastNameORG"];
                                                   [defaults removeObjectForKey:@"EmailORG"];
                                                   [defaults removeObjectForKey:@"MobileORG"];
                                                   [defaults removeObjectForKey:@"DOBORG"];
                                                   
                                                   ActivationViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivationViewController"];
                                                   AVC.activationCode=activateCode;
                                                   [self.navigationController pushViewController:AVC animated:YES];                                           }];
                
                [alertController addAction:cancelAction];
                [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
                UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
                [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if ([errorStatus isEqualToString:@"400"]){
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:[[json valueForKey:@"errors"]objectAtIndex:0]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction *action)
                                               {
                                                   
                                                   
                                               }];
                
                [alertController addAction:cancelAction];
                [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
                UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
                [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD hide:YES];
            if ([error code] == kCFURLErrorNotConnectedToInternet)
            {
            }else if([error code]==kCFURLErrorTimedOut){
                [self showAlert:[error localizedDescription]];
            }else if([error code]==kCFURLErrorBadServerResponse){
                [self showAlert:[error localizedDescription]];
            }else if([error code]==kCFURLErrorCannotConnectToHost){
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }
            else
            {
                // otherwise handle the error generically
                //[self handleError:error];
            }
            
        }];
        [op start];
        
        
    }

    
    
}

- (IBAction)Dots:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.tag==0) {
        OraganizationSignUpTwo *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpTwo"];
        [self.navigationController pushViewController:singUpOne animated:YES];
    }else if (button.tag==1){
        OraganizationSignUpThree *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpThree"];
        [self.navigationController pushViewController:singUpOne animated:YES];

    }
    else if (button.tag==2){
        OraganizationSignUpFour *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpFour"];
        [self.navigationController pushViewController:singUpOne animated:YES];

          } else if (button.tag==3){
    }
    
    
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
-(void)getstureAnonmous{
    
    NSString *temp=[defaults valueForKey:@"TERMSORG"];
    if ([temp isEqualToString:@"isTermsChecked"]) {
        isTermsValidate=@"1";
        [self.termsButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TERMSORG"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"isTermsChecked" forKey:@"TERMSORG"];
        isTermsValidate=@"0";
        [self.termsButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        TermsAndConditionViewController *terms=[self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
        [self.navigationController pushViewController:terms animated:YES];
    }
}
@end
