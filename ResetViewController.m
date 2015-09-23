//
//  ResetViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ResetViewController.h"
#import "ForgotPasswordViewController.h"
#import "CommonMethodClass.h"
#import "KLCPopup.h"

#import "RequestFeedViewController.h"
@interface ResetViewController ()
{
    NSUserDefaults *defaults;
}
- (IBAction)ResetView:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation ResetViewController
@synthesize NewPass,rePass;
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
    defaults=[NSUserDefaults standardUserDefaults];
    UIColor *placeHoler=[CommonMethodClass pxColorWithHexValue:@"#A4E4FC"];
    rePass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Re-enter Passwrod" attributes:@{NSForegroundColorAttributeName: placeHoler}];
    
    rePass.font = [UIFont fontWithName:@"Myriad Pro" size:17.0f];
    
    NewPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter New Password" attributes:@{NSForegroundColorAttributeName: placeHoler}];
    
    NewPass.font = [UIFont fontWithName:@"Myriad Pro" size:17.0f];

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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)ResetView:(id)sender {
      [self HUDAction];
     NSMutableDictionary *postData=[[NSMutableDictionary alloc]init];
    [postData setObject:[defaults valueForKey:@"ForgotPasswordActivationCode"] forKey:@"code"];
    [postData setObject:self.NewPass.text forKey:@"password"];
    [postData setObject:self.rePass.text forKey:@"password_confirmation"];
    NSLog(@"%@",postData);
    NSMutableURLRequest*   request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/resetPassword" dictornay:postData];
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
            [self show];
            [self performSelector:@selector(goToLogin) withObject:nil afterDelay:0.5];
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
    
  
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goToLogin{
    ViewController *FPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:FPVC animated:YES];
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
-(void)show{
    
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    UIColor *colow=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    contentView.backgroundColor=colow;
    
    contentView.layer.cornerRadius = 10.0;
    
    UILabel* HeaderLbl = [[UILabel alloc] init];
    HeaderLbl.translatesAutoresizingMaskIntoConstraints = NO;
    HeaderLbl.font = [UIFont boldSystemFontOfSize:17.0];
    HeaderLbl.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
    UIColor *colo=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    HeaderLbl.backgroundColor=[UIColor whiteColor];
    HeaderLbl.text=@"Passsword Changed!";
    HeaderLbl.textColor=colo;
    HeaderLbl.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:HeaderLbl];
    
    UIImageView *dot =[[UIImageView alloc] init];
    dot.translatesAutoresizingMaskIntoConstraints = NO;
    dot.image=[UIImage imageNamed:@"successtick.png"];
    [contentView addSubview:dot];
    
    
    //constraints for popup view
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, HeaderLbl,dot);
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(200)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    
    NSArray *constraint_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentView(250)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    
    [contentView addConstraints:constraint_H];
    [contentView addConstraints:constraint_W];
    //constraints for header label width/height
    NSArray *HeaderLabel_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[HeaderLbl(250)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    
    NSArray *HeaderLabel_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[HeaderLbl(60)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [HeaderLbl addConstraints:HeaderLabel_H];
    [HeaderLbl addConstraints:HeaderLabel_W];
    
    //header label to content view
    NSArray *headerLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(140)-[HeaderLbl(60)]-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    
    NSArray *headerLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[HeaderLbl]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    
    [contentView addConstraints:headerLbl_V];
    [contentView addConstraints:headerLbl_H];
    
    NSArray *image_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[dot(62)]"
                                                               options:0
                                                               metrics:nil
                                                                 views:views];
    
    NSArray *image_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dot(61)]"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    [dot addConstraints:image_W];
    [dot addConstraints:image_H];
    
    NSArray *Image_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[dot(61)]-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:views];
    
    NSArray *Image_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(90)-[dot(62)]|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    
    
    [contentView addConstraints:Image_V];
    [contentView addConstraints:Image_H];
    
    
    
    // Show in popup
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                            showType:KLCPopupShowTypeSlideInFromTop
                                         dismissType:KLCPopupDismissTypeBounceOutToBottom
                                            maskType:KLCPopupMaskTypeNone
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:YES];
    [popup showWithLayout:layout duration:0.4];
    
}
@end
