//
//  OraganizationSignUpThree.m
//  GPRegisterApp
//
//  Created by Macbook Pro  on 9/14/15.
//  Copyright (c) 2015 Macbook Pro . All rights reserved.
//

#import "OraganizationSignUpThree.h"
#import "OraganizationSignUpOne.h"
#import "OraganizationSignUpTwo.h"
#import "OraganizationSignUpFour.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "CommonMethodClass.h"
#import "MBProgressHUD.h"
#import "UILabel+changeAppearance.h"
#import "ViewController.h"
@interface OraganizationSignUpThree (){
    MBProgressHUD *HUD;
    NSUserDefaults *defaults;

}
- (IBAction)countryList:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UITextField *addressOne;
@property (weak, nonatomic) IBOutlet UITextField *addressTwo;
- (IBAction)stateList:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UITextField *ZipCodeText;
- (IBAction)cityList:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
- (IBAction)NextAction:(id)sender;
- (IBAction)Dots:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
- (IBAction)SignInView:(id)sender;

@end

@implementation OraganizationSignUpThree
@synthesize datasList,stateList,cityList,valuesList;
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
    [self.buttonThree setImage:[UIImage imageNamed:@"selecteddot.png"] forState:UIControlStateNormal];
    height=250;
    valuesList=[[NSMutableArray alloc]init];
    datasList=[NSMutableArray array];
    stateList =[NSMutableArray array];
    cityList=[NSMutableArray array];
    dropDown=[[NIDropDown alloc]init];
    dropDown.delegate = self;
    [self listCountry];
    self.addressOne.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Address 1" color:[UIColor whiteColor]];
    self.addressTwo.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"Address 2" color:[UIColor whiteColor]];
    self.ZipCodeText.attributedPlaceholder =[CommonMethodClass PlaceHolderTextApperance:@"ZipCode" color:[UIColor whiteColor]];
    self.cityButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.countryButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.stateButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;

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
-(void)listCountry{
    [self HUDAction];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:@"http://192.237.241.156:9000/v1/address/countries"];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"------->hgfkjfhg%@",responseObject);
        [HUD hide:YES];
        NSDictionary *json=(NSDictionary *)responseObject;
        NSDictionary *countryList=[json valueForKey:@"message"];
        NSArray *values=[countryList valueForKey:@"countryList"];
        NSMutableDictionary *temp;
        for (NSDictionary *obj in values) {
            temp=[NSMutableDictionary dictionary];
            [temp setObject:[obj valueForKey:@"id"] forKey:@"ID"];
            [temp setObject:[obj valueForKey:@"name"] forKey:@"NAME"];
            [temp setObject:[obj valueForKey:@"sortname"] forKey:@"SHORTNAME"];
            [datasList addObject:temp];
        }
        NSLog(@"%@",datasList);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
        }else if([error code]==kCFURLErrorTimedOut){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }else if([error code]==kCFURLErrorBadServerResponse){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }else{
            // otherwise handle the error generically
            //[self handleError:error];
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
            
        }
        
    }];
    [op start];
    
}

- (IBAction)countryList:(id)sender {
    [activeField resignFirstResponder];
    CheckStringToPostId=@"country";
    for (int i=0;i<[datasList count]; i++) {
        [valuesList addObject:[[datasList valueForKey:@"NAME"]objectAtIndex:i]];
    }
    if (isCountry==NO) {
        isCountry=YES;
        [dropDown showDropDown:sender :&height :valuesList :nil :@"down"];
        dropDown.delegate = self;
        
    }
    else{
        isCountry=NO;
        [dropDown hideDropDown:sender];
        
    }

}
- (IBAction)stateList:(id)sender {
    [activeField resignFirstResponder];
    CheckStringToPostId=@"state";
    NSString*temp= [self.countryButton currentTitle];
    if ([temp isEqualToString:@"Country"]) {
        [self showAlert:@"Please choose your Country"];
    }else{
        
        if (isState==NO) {
            isState=YES;
            NSString *stateUrl=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/address/states?country_id=%@",[[self.datasList valueForKey:@"ID"] objectAtIndex:selectedIndex]] ;
            
            [self HUDAction];
            NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:stateUrl];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"------->hgfkjfhg%@",responseObject);
                [HUD hide:YES];
                NSDictionary *json=(NSDictionary *)responseObject;
                NSDictionary *countryList=[json valueForKey:@"message"];
                NSArray *values=[countryList valueForKey:@"stateList"];
                NSMutableDictionary *temp;
                for (NSDictionary *obj in values) {
                    temp=[NSMutableDictionary dictionary];
                    [temp setObject:[obj valueForKey:@"id"] forKey:@"STATEID"];
                    [temp setObject:[obj valueForKey:@"name"] forKey:@"STATENAME"];
                    [temp setObject:[obj valueForKey:@"country_id"] forKey:@"COUNTRYID"];
                    [stateList addObject:temp];
                }
                NSLog(@"%@",stateList);
                [valuesList removeAllObjects];
                for (int i=0;i<[stateList count]; i++) {
                    [valuesList addObject:[[stateList valueForKey:@"STATENAME"]objectAtIndex:i]];
                }
                height=170;
                [dropDown showDropDown:sender :&height :valuesList :nil :@"up"];
                dropDown.delegate = self;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [HUD hide:YES];
                if ([error code] == kCFURLErrorNotConnectedToInternet)
                {
                }else if([error code]==kCFURLErrorTimedOut){
                    [self showAlert:[error localizedDescription]];
                }else if([error code]==kCFURLErrorBadServerResponse){
                    [self showAlert:[error localizedDescription]];
                }
                else
                {
                    // otherwise handle the error generically
                    //[self handleError:error];
                }
                
            }];
            [op start];
        }
        else{
            isState=NO;
            [dropDown hideDropDown:sender];
            
        }
    }

}
- (IBAction)cityList:(id)sender {
    [activeField resignFirstResponder];
    CheckStringToPostId=@"city";
    
    NSString*temp= [self.stateButton currentTitle];
    if ([temp isEqualToString:@"State"]) {
        [self showAlert:@"Please choose your State"];
    }else{
        if (isCity==NO) {
            isCity=YES;
            NSLog(@"%@",self.stateList);
            NSString *stateUrl=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/address/cities?state_id=%@",[[self.stateList valueForKey:@"STATEID"] objectAtIndex:selectedIndex]] ;
            [self HUDAction];
            NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:stateUrl];
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"------->hgfkjfhg%@",responseObject);
                [HUD hide:YES];
                NSDictionary *json=(NSDictionary *)responseObject;
                NSDictionary *countryList=[json valueForKey:@"message"];
                NSArray *values=[countryList valueForKey:@"cityList"];
                NSMutableDictionary *temp;
                for (NSDictionary *obj in values) {
                    temp=[NSMutableDictionary dictionary];
                    [temp setObject:[obj valueForKey:@"id"] forKey:@"CITYID"];
                    [temp setObject:[obj valueForKey:@"name"] forKey:@"CITYNAME"];
                    [temp setObject:[obj valueForKey:@"state_id"] forKey:@"STATEID"];
                    [cityList addObject:temp];
                }
                NSLog(@"%@",cityList);
                [valuesList removeAllObjects];
                for (int i=0;i<[cityList count]; i++) {
                    [valuesList addObject:[[cityList valueForKey:@"CITYNAME"]objectAtIndex:i]];
                }
                if ([cityList count]==0) {
                    [self showAlert:@"City Not Found"];
                    
                }else{
                    height=200;
                    [dropDown showDropDown:sender :&height :valuesList :nil :@"up"];
                    dropDown.delegate = self;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [HUD hide:YES];
                if ([error code] == kCFURLErrorNotConnectedToInternet)
                {
                }else if([error code]==kCFURLErrorTimedOut){
                    [self showAlert:[error localizedDescription]];
                }else if([error code]==kCFURLErrorBadServerResponse){
                    [self showAlert:[error localizedDescription]];
                }
                else
                {
                    // otherwise handle the error generically
                    //[self handleError:error];
                }
                
            }];
            [op start];
            
            
        }
        else{
            isCity=NO;
            [dropDown hideDropDown:sender];
        }
    }

}


- (IBAction)Dots:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.tag==0) {
        OraganizationSignUpOne *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpOne"];
        [self.navigationController pushViewController:singUpOne animated:YES];
    }else if (button.tag==1){
        OraganizationSignUpTwo *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpTwo"];
        [self.navigationController pushViewController:singUpOne animated:YES];
    }
    else if (button.tag==2){
       
    } else if (button.tag==3){
        OraganizationSignUpFour *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpFour"];
        [self validate:singUpOne];
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
-(void)selectedIndex:(int)index{
    selectedIndex=index;
    if([CheckStringToPostId isEqualToString:@"country"]){
        countryIdPost= [NSString stringWithFormat:@"%@",[[self.datasList valueForKey:@"ID"]objectAtIndex:selectedIndex]];
    }else if([CheckStringToPostId isEqualToString:@"state"]){
        stateIdPost=[NSString stringWithFormat:@"%@",[[self.stateList valueForKey:@"STATEID"]objectAtIndex:selectedIndex]];
    }else if([CheckStringToPostId isEqualToString:@"city"]){
        cityIdPost=[[self.cityList valueForKey:@"CITYID"]objectAtIndex:selectedIndex];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
}
-(void)selectedString:(NSString *)text
{
    NSLog(@"hi");
    
}
- (IBAction)NextAction:(id)sender {
    OraganizationSignUpFour *singUpOne=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpFour"];
    [self validate:singUpOne];

}
-(void)validate:(UIViewController *)goToViewController{
    NSString*temp= [self.countryButton currentTitle];
    if ([temp isEqualToString:@"Country"]) {
        [self showAlert:@"Please choose your Country"];
    }else if ([self.addressOne.text isEqualToString:@""]){
        [self showAlert:@"Please fill your first address field"];
    }else if ([self.addressTwo.text isEqualToString:@""]){
        [self showAlert:@"Please fill your second address field"];
    }else if ([self.ZipCodeText.text isEqualToString:@""]){
        [self showAlert:@"Please enter your zipcode"];
        
    }
    else{
        [defaults setObject:countryIdPost forKey:@"Country"];
        [defaults setObject:stateIdPost forKey:@"State"];
        [defaults setObject:cityIdPost forKey:@"City"];
        [defaults setObject:self.addressOne.text forKey:@"AddressOne"];
        [defaults setObject:self.addressTwo.text forKey:@"AddressTwo"];
        [defaults setObject:self.ZipCodeText.text forKey:@"ZipCode"];
        [self.navigationController pushViewController:goToViewController animated:YES];

    }

}

@end
