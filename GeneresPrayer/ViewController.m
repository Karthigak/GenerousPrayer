//
//  ViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "ForgotViewController.h"
#import "TestViewController.h"
#import "CommonMethodClass.h"
#import "MBProgressHUD.h"
#import "CustomAFNetworking.h"
#import "AFNetworking.h"
#import "OnboardingPageviewController.h"
#import "ActivityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageAnimation.h"
#import "UILabel+changeAppearance.h"
#import "CRMotionView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()<UITextFieldDelegate>
{
    BOOL isChecked;
    NSUserDefaults *defaluts;
    MBProgressHUD *HUD;
    NSMutableArray *imageArray;

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnRemberMe;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;
- (IBAction)registerView:(id)sender;
- (IBAction)RememberMe:(id)sender;
- (IBAction)ForgotView:(id)sender;

@end

@implementation ViewController
@synthesize userName,password,BgImageView,scrollView,btnRemberMe;
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
    imageArray=[NSMutableArray array];
    defaluts=[NSUserDefaults standardUserDefaults];
    isChecked=YES;
    self.scrollView.contentSize=CGSizeMake(0, 700);
   // [self getImagesToAnimate];
    CRMotionView *motionView = [self motionViewWithImage];
    [motionView setScrollDragEnabled:YES];
    [motionView setScrollBounceEnabled:YES];
    [motionView setScrollIndicatorEnabled:NO];

//
}

- (CRMotionView *)motionViewWithImage
{
    CRMotionView *motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[temp objectAtIndex:0]];
    BgImageView.image=[UIImage imageNamed:@"bg.png"];
    [motionView setContentView:BgImageView];
//   [self.view addSubview:motionView];
    [self.view insertSubview:motionView belowSubview:self.scrollView];

    return motionView;
}
-(void)getImagesToAnimate{
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:@"http://192.237.241.156:9000/v1/login_banners"
];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"------->hgfkjfhg%@",responseObject);
    
            for (NSDictionary *dic in responseObject) {
                [imageArray addObject:[dic valueForKey:@"login_backrgound_url"]];
            }
            if ([responseObject count]==[imageArray count]) {
//                NSArray *temp=[ImageAnimation animatedImage:imageArray];
//                BgImageView.animationImages = temp;
//                BgImageView.animationDuration =9.0;
//                BgImageView.animationRepeatCount = 0;
//                [BgImageView startAnimating];
                           }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
            [HUD hide:YES];
            
            if ([error code] == kCFURLErrorNotConnectedToInternet)
            {
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
                
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

}
-(void)viewWillAppear:(BOOL)animated
{
    
    //
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *nameRember=[defaluts valueForKey:@"USERNAME"];
    NSString *passRember=[defaluts valueForKey:@"PASSWORD"];
    if ([CommonMethodClass isEmpty:nameRember] && [CommonMethodClass isEmpty:passRember])
    {
        userName.text=@"";
        password.text=@"";
        [self.btnRemberMe setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        isChecked=YES;
    }
    else
    {
        userName.text=nameRember;
        password.text=passRember;
        [self.btnRemberMe setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        isChecked=NO;
        
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    scrollView=nil;
    btnRemberMe=nil;
    imageArray=nil;
    activeField=nil;
    HUD=nil;
    
}

- (IBAction)login:(id)sender {
    if ([self.userName.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Please enter your Email address or Mobile number"
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
        
 
    }else if ([self.password.text isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Please enter your Password"
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

    }else{
    if(isChecked==NO) {
        [defaluts setObject:userName.text forKey:@"USERNAME"];
        [defaluts setObject:password.text forKey:@"PASSWORD"];
    }
    [self HUDAction];
    NSMutableDictionary *postData=[[NSMutableDictionary alloc]init];
    [postData setObject:self.userName.text forKey:@"username"];
    [postData setObject:self.password.text forKey:@"password"];
   // NSString *devToken = [defaluts valueForKey:@"deviceToken"];
    NSString *devToken = @"12234";
    NSDictionary *passData = @{@"user":postData,@"device_id":devToken};//@"12234"
    NSLog(@"%@",passData);
    NSMutableURLRequest*   request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/users/login" dictornay:passData];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"------->hgfkjfhg%@",responseObject);
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if ([errorState isEqualToString:@"401"]) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:[responseObject valueForKey:@"errors"]
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
        }else if([errorState isEqualToString:@"400"]){
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:[responseObject valueForKey:@"errors"]
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
        else
        {
            [defaluts setObject:[responseObject valueForKey:@"token"] forKey:@"TOKEN"];
            
            NSString *typeOfLogin=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"user_type_id"]];
            [defaluts setObject:typeOfLogin forKey:@"USERTYPE"];

            NSString *temp=[defaluts valueForKey:@"First"];
            if ([temp isEqualToString:@"YES"]) {
                ActivityViewController  *homeObj=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
                [self.navigationController pushViewController:homeObj animated:YES];
            }
            
            else{
                TestViewController  *homeObj=[self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
                [defaluts setObject:@"YES" forKey:@"First"];        [self.navigationController pushViewController:homeObj animated:YES];
            }

        }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];

        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
            [CommonMethodClass showAlert:[error localizedDescription] view:self];

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
    }
 
}

- (IBAction)registerView:(id)sender {
        // Generate content view to present
    OnboardingPageviewController *homeObj=[self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingPageviewController"];
    homeObj.checkString=@"fromLogin";
        [self.navigationController pushViewController:homeObj animated:YES];
    
}
- (IBAction)RememberMe:(id)sender {
    if (isChecked) {
          [self.btnRemberMe setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [defaluts setObject:userName.text forKey:@"USERNAME"];
        [defaluts setObject:password.text forKey:@"PASSWORD"];
        [defaluts synchronize];
        isChecked=NO;
    }
    else
    {
         [self.btnRemberMe setBackgroundImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        [defaluts setObject:@"" forKey:@"USERNAME"];
        [defaluts setObject:@"" forKey:@"PASSWORD"];
        isChecked=YES;
    }
}

- (IBAction)ForgotView:(id)sender {
    
    ForgotViewController *FVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotViewController"];
    [self.navigationController pushViewController:FVC animated:YES];
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

@end
