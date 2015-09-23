//
//  ForgotViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ForgotViewController.h"
#import "ActivationViewController.h"
#import "ResetViewController.h"
#import "CommonMethodClass.h"
#import "KLCPopup.h"
#import "ForgotPasswordViewController.h"
#import "LGActionSheet.h"
@interface ForgotViewController()<LGActionSheetDelegate>{
    NSString *DateOfBirth;
//    NSInteger currentYear;
//    NSInteger currentMonth;

}
- (IBAction)back:(id)sender;
- (IBAction)submitAction:(id)sender;

@end

@implementation ForgotViewController
@synthesize dob,email;

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
    self.navigationController.navigationBarHidden=YES;
    
    dob.font = [UIFont fontWithName:@"Myriad Pro" size:17.0f];
    
    UIColor *placeHoler=[CommonMethodClass pxColorWithHexValue:@"#A4E4FC"];
    dob.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Date Of Birth" attributes:@{NSForegroundColorAttributeName: placeHoler}];
    
    email.font = [UIFont fontWithName:@"Myriad Pro" size:17.0f];
   
    email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address or Mobile" attributes:@{NSForegroundColorAttributeName: placeHoler}];
    // Do any additional setup after loading the view.
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
    textField.layer.borderColor=[[UIColor lightGrayColor] CGColor];
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
        //viewFrame.origin.x -= animatedDistance+25;
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
       // viewFrame.origin.x += animatedDistance+25;
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index{
    self.dob.text=DateOfBirth;
}
-(void)selectedDateOfBirth:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    DateOfBirth = [dateFormatter stringFromDate:datePicker.date];

}
-(void)datePicker
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.frame = CGRectMake(0.f, 0.f, datePicker.frame.size.width, 100.f);
    datePicker.datePickerMode=UIDatePickerModeDate;
    [datePicker setMaximumDate:[NSDate date]]; // The max date will be today
    [datePicker addTarget:self action:@selector(selectedDateOfBirth:) forControlEvents:UIControlEventValueChanged];
    LGActionSheet *actionSheet=[[LGActionSheet alloc] initWithTitle:@"Choose Your Birth date, please"
                                                               view:datePicker
                                                       buttonTitles:@[@"Done"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
    actionSheet.delegate=self;
    [actionSheet showAnimated:YES completionHandler:nil];
}

- (IBAction)showDatePicker:(id)sender {
    [self.email resignFirstResponder];
    [activeField resignFirstResponder];
    [self datePicker];
}
- (IBAction)submitAction:(id)sender {
    
    
    [self HUDAction];
    NSMutableDictionary *postData=[[NSMutableDictionary alloc]init];
    [postData setObject:self.dob.text forKey:@"dob"];
    [postData setObject:self.email.text forKey:@"username"];
    
    [[NSUserDefaults standardUserDefaults]setObject:self.dob.text forKey:@"ResetDob"];
    [[NSUserDefaults standardUserDefaults]setObject:self.email.text forKey:@"ResetEmail"];

    NSLog(@"%@",postData);
    
    
    NSMutableURLRequest*   request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/forgetPassword" dictornay:postData];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"------->hgfkjfhg%@",responseObject);
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
         NSString *successState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([errorState isEqualToString:@"400"]) {
            [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
        }
        
        else if ([successState isEqualToString:@"200"]){
                   [CommonMethodClass showAlert:[responseObject valueForKey:@"message"]  view:self];
            [self performSelector:@selector(reset) withObject:nil afterDelay:0.5];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
        }else if([error code]==kCFURLErrorTimedOut){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }else if([error code]==kCFURLErrorBadServerResponse){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
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

//    ForgotPasswordViewController *RVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
//    [self.navigationController pushViewController:RVC animated:YES];
    
}
-(void)reset{
    ForgotPasswordViewController *RVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self.navigationController pushViewController:RVC animated:YES];
}
@end
