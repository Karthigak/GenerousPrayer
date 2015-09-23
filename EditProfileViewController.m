//
//  EditProfileViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "EditProfileViewController.h"
#import "SettingViewController.h"
#import "CommonMethodClass.h"
#import "MyFriendsListViewController.h"
#import "NIDropDown.h"
#import "Constants.h"
#import "UIImage+fixOrientation.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UILabel+changeAppearance.h"

@interface EditProfileViewController ()<NIDropDownDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UISegmentedControl *obj;
    NSString *selectedStringValue;
    NIDropDown *dropDown;
    NSUserDefaults *userInfo;
    NSMutableArray *sources;
    UIActionSheet *actionSheet;
    MBProgressHUD *HUD;
    NSArray * arr;
    int selectedIndex;

    
    //individul for drop down
    
    BOOL isFirst;
    BOOL isSecond;
    BOOL isThird;
    
    
    //organization
    
    BOOL isCountry;
    BOOL isState;
    BOOL isCity;
    NSString *CheckStringToPostId;
    NSString *cityIdPost;
    NSString *stateIdPost;
    NSString *countryIdPost;
    CGFloat height;
    NSDictionary *userDetails;
    
    
    //visiiblity check
    
    NSString *visibleEmail;
    NSString *visiblePhone;
    NSString *visibleAddress;


}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewOne;
@property (strong, nonatomic) IBOutlet UITextField *commonText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *dpOne;
@property (weak, nonatomic) IBOutlet UIButton *dpTwo;
@property (weak, nonatomic) IBOutlet UITextField *countryName;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *dpThree;
@property(strong,nonatomic)NSMutableArray *datasList;
@property(strong,nonatomic)NSMutableArray *valuesList;

@property(strong,nonatomic)NSMutableArray *stateList;
@property(strong,nonatomic)NSMutableArray *cityList;

- (IBAction)dropDownOne:(id)sender;
- (IBAction)dropDownTwo:(id)sender;
- (IBAction)dropDownThree:(id)sender;

- (IBAction)editProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *individualAddress;
@property (strong, nonatomic) IBOutlet UITextField *individualEmail;
@property (strong, nonatomic) IBOutlet UITextField *individualPhone;

@property (strong, nonatomic) IBOutlet UITextField *nameText;


//organization

@property (strong, nonatomic) IBOutlet UIButton *countryButton;
- (IBAction)country:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *stateButton;
- (IBAction)state:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cityButton;
- (IBAction)cityAction:(id)sender;

@end

@implementation EditProfileViewController
@synthesize countryName,username,email,phoneNumber,profileImage,datasList,valuesList,stateList,cityList;
-(void)drawLable
{
    if (isiPad) {
        
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,1024, self.naviLbl.bounds.size.height)];
    }
    else
    {
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,600, self.naviLbl.bounds.size.height)];
    }
    CALayer *layer = self.naviLbl.layer;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
    
}

-(void)topShadowLable
{
    if (isiPad) {
        [self.topShadowLbl setFrame:CGRectMake(self.topShadowLbl.bounds.origin.x, self.topShadowLbl.bounds.origin.y,1024, self.topShadowLbl.bounds.size.height)];
    }else{
        [self.topShadowLbl setFrame:CGRectMake(self.topShadowLbl.bounds.origin.x, self.topShadowLbl.bounds.origin.y,600, self.topShadowLbl.bounds.size.height)];
    }

    CALayer *layer = self.topShadowLbl.layer;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.topShadowLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f,0.5f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
}
-(void)preFillDatas:(NSDictionary *)dic{
    NSLog(@":%@",dic);
    NSString *userType=[userInfo valueForKey:@"USERTYPE"];
    NSDictionary *temp=[dic valueForKey:@"my_profile_info"];
    if ([userType isEqualToString:@"0"]) {
        self.individualEmail.text=[temp valueForKey:@"email"];
        self.individualPhone.text=[temp valueForKey:@"mobile"];
        self.commonText.text=[temp valueForKey:@"first_name"];
        NSString *userImage=[NSString stringWithFormat:@"%@",[temp valueForKey:@"image_url"]];
        if ([userImage isEqualToString:@""]) {
            
        }else{
            profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
            profileImage.layer.masksToBounds = YES;
            profileImage.layer.borderWidth = 6;
            profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:1.0f] CGColor];
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache]clearDisk];
            NSURL *URL2 = [NSURL URLWithString:[temp valueForKey:@"image_url"]];
            NSURLRequest* request2 = [NSURLRequest requestWithURL:URL2];
            [NSURLConnection sendAsynchronousRequest:request2
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse * response,
                                                       NSData * data2,
                                                       NSError * error) {
                                       if (!error){
                                           
                                           self.profileImage.image=[UIImage imageWithData:data2];                                   }
                                       
                                   }];
            
        }

        if ([[temp valueForKey:@"user_visibility"] isKindOfClass:[NSDictionary class]]) {
            
            NSString *visib=[NSString stringWithFormat:@"%@",[[temp valueForKey:@"user_visibility"]valueForKey:@"email_visibility_state"]];
            if ([visib isEqualToString:@"0"]) {
                [self.dpOne setTitle:@"Public" forState:UIControlStateNormal];
                
            }else if ([visib isEqualToString:@"1"]){
                [self.dpOne setTitle:@"Private" forState:UIControlStateNormal];
            }else{
                [self.dpOne setTitle:@"Friends" forState:UIControlStateNormal];
            }
        }if ([[temp valueForKey:@"user_visibility"] isKindOfClass:[NSDictionary class]]) {
            NSString *visib=[NSString stringWithFormat:@"%@",[[temp valueForKey:@"user_visibility"]valueForKey:@"mobile_visibility_state"]];
            if ([visib isEqualToString:@"0"]) {
                [self.dpTwo setTitle:@"Public" forState:UIControlStateNormal];
                
            }else if ([visib isEqualToString:@"1"]){
                [self.dpTwo setTitle:@"Private" forState:UIControlStateNormal];
            }else{
                [self.dpTwo setTitle:@"Friends" forState:UIControlStateNormal];
            }
        }
    }else{
        self.commonText.text=[temp valueForKey:@"first_name"];
        if ([[temp valueForKey:@"address_1"] isKindOfClass:[NSNull class]]) {
            
        }else{
            address1.text=[temp valueForKey:@"address_1"];
        } if ([[temp valueForKey:@"address_2"] isKindOfClass:[NSNull class]]) {
            
        }else{
            address2.text=[temp valueForKey:@"address_2"];
        }if ([[temp valueForKey:@"pincode"] isKindOfClass:[NSNull class]]) {
            
        }else{
            zipcode.text=[temp valueForKey:@"pincode"];
        }

        
        email.text=[temp valueForKey:@"email"];
        mobile.text=[temp valueForKey:@"mobile"];
        if ([[temp valueForKey:@"state"] isKindOfClass:[NSDictionary class]]) {
            state.text=[[temp valueForKey:@"state"]valueForKey:@"name"];
            stateIdPost=[[temp valueForKey:@"state"]valueForKey:@"id"];
        } if ([[temp valueForKey:@"city"] isKindOfClass:[NSDictionary class]]) {
            city.text=[[temp valueForKey:@"city"]valueForKey:@"name"];
            cityIdPost=[[temp valueForKey:@"city"]valueForKey:@"id"];
        } if ([[temp valueForKey:@"country"] isKindOfClass:[NSDictionary class]]) {
            country.text=[[temp valueForKey:@"country"]valueForKey:@"name"];
            countryIdPost=[[temp valueForKey:@"country"]valueForKey:@"id"];
        }
//        if ([[temp valueForKey:@"state"] isKindOfClass:[NSNull class]]) {
//            
//        }else{
//            state.text=[temp valueForKey:@"state"];
//        } if ([[temp valueForKey:@"country"] isKindOfClass:[NSNull class]]) {
//            
//        }else{
//            country.text=[temp valueForKey:@"country"];
//        }if ([[temp valueForKey:@"city"] isKindOfClass:[NSNull class]]) {
//            
//        }else{
//            if ([[temp valueForKey:@"city"] isKindOfClass:[NSDictionary class]]) {
//                city.text=[[temp valueForKey:@"city"]valueForKey:@"name"
//                           ];
//
//            }
//
//        }
        if ([[temp valueForKey:@"user_visibility"] isKindOfClass:[NSDictionary class]]) {
            NSString *visib=[NSString stringWithFormat:@"%@",[[temp valueForKey:@"user_visibility"]valueForKey:@"email_visibility_state"]];
            if ([visib isEqualToString:@"0"]) {
                [self.dpOne setTitle:@"Public" forState:UIControlStateNormal];
            }else if ([visib isEqualToString:@"1"]){
                [self.dpOne setTitle:@"Private" forState:UIControlStateNormal];
            }else{
                [self.dpOne setTitle:@"Friends" forState:UIControlStateNormal];
             }
        }if ([[temp valueForKey:@"user_visibility"] isKindOfClass:[NSDictionary class]]) {
            NSString *visib=[NSString stringWithFormat:@"%@",[[temp valueForKey:@"user_visibility"]valueForKey:@"mobile_visibility_state"]];
            if ([visib isEqualToString:@"0"]) {
                [self.dpTwo setTitle:@"Public" forState:UIControlStateNormal];
                
            }else if ([visib isEqualToString:@"1"]){
                [self.dpTwo setTitle:@"Private" forState:UIControlStateNormal];
            }else{
                [self.dpTwo setTitle:@"Friends" forState:UIControlStateNormal];
            }
        }if ([[temp valueForKey:@"user_visibility"] isKindOfClass:[NSDictionary class]]) {
            NSString *visib=[NSString stringWithFormat:@"%@",[[temp valueForKey:@"user_visibility"]valueForKey:@"address_visibility_state"]];
            if ([visib isEqualToString:@"0"]) {
                [self.dpThree setTitle:@"Public" forState:UIControlStateNormal];
                
            }else if ([visib isEqualToString:@"1"]){
                [self.dpThree setTitle:@"Private" forState:UIControlStateNormal];
            }else{
                [self.dpThree setTitle:@"Friends" forState:UIControlStateNormal];
            }
        }
        NSString *userImage=[NSString stringWithFormat:@"%@",[temp valueForKey:@"image_url"]];
        if ([userImage isEqualToString:@""]) {
            
        }else{
            profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
            profileImage.layer.masksToBounds = YES;
            profileImage.layer.borderWidth = 6;
            profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:1.0f] CGColor];
            [[SDImageCache sharedImageCache]clearMemory];
            [[SDImageCache sharedImageCache]clearDisk];
            NSURL *URL2 = [NSURL URLWithString:[temp valueForKey:@"image_url"]];
            NSURLRequest* request2 = [NSURLRequest requestWithURL:URL2];
            [NSURLConnection sendAsynchronousRequest:request2
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse * response,
                                                       NSData * data2,
                                                       NSError * error) {
                                       if (!error){
                                           
                                           self.profileImage.image=[UIImage imageWithData:data2];                                   }
                                       
                                   }];

        }
    }
    
}
-(void)preLoad{
  userDetails = [NSKeyedUnarchiver unarchiveObjectWithData:[userInfo valueForKey:@"USERDETAILS"]];
    NSString *userType=[userInfo valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"0"]) {
        self.scrollViewOne.hidden=YES;
        [self preFillDatas:userDetails];
    }else{
        self.scrollView.hidden=YES;
        
        [self preFillDatas:userDetails];
        [self listCountry];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
        }
        else{
            [tabBar removeFromSuperview];
            [self tab];
        }
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
        }
        else{
            
        }
    }
}

-(void)HUDAction{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];
    [self preLoad];

    self.email.userInteractionEnabled=NO;
    self.individualEmail.userInteractionEnabled=NO;

    cityIdPost=@"12";//hard coded for temporary solutions
    arr = [NSArray arrayWithObjects:@"Friends", @"Public", @"Private",nil];
    [self topShadowLable];
    [self drawLable];
    dropDown=[[NIDropDown alloc]init];
    dropDown.delegate = self;
    height=150;
    valuesList=[[NSMutableArray alloc]init];
    datasList=[NSMutableArray array];
    stateList =[NSMutableArray array];
    cityList=[NSMutableArray array];
    self.cityButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.countryButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.stateButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#2A50AB"];
    UIColor *tintColor=[CommonMethodClass pxColorWithHexValue:@"#3D62B3"];
    [self.topBar setTitle:@"Public" forSegmentAtIndex:2];
    self.topBar.backgroundColor = backColor;
    self.topBar.tintColor =tintColor;
    self.topBar.layer.borderColor=[UIColor clearColor].CGColor;
    self.topBar.layer.cornerRadius = 0.0;
    self.topBar.layer.borderWidth = .0f;
    self.topBar.selectedSegmentIndex=0;
    UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#A1CD46"];
    // UIColor *unselectedFont=[CommonMethodClass pxColorWithHexValue:@"#C7F0F9"];
    UIColor *unselectedFont=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[unselectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    
    NSDictionary *attributess = [NSDictionary dictionaryWithObjects:@[selectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributess
                               forState:UIControlStateSelected];
    [self.topBar addTarget:self action:@selector(HeaderAction:) forControlEvents:UIControlEventValueChanged];
// [self.topBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Pro" size:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    
    zipcode.attributedPlaceholder =[self PlaceHolderTextApperance:@"Password" color:[UIColor whiteColor]];
    address1.attributedPlaceholder =[self PlaceHolderTextApperance:@"Confirm Password" color:[UIColor whiteColor]];
     address2.attributedPlaceholder =[self PlaceHolderTextApperance:@"Confirm Password" color:[UIColor whiteColor]];

}
-(NSAttributedString *)PlaceHolderTextApperance:(NSString *)str color:(UIColor *)color{
    
    
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
                                                        NSFontAttributeName : [UIFont fontWithName:@"Myriad Pro" size:17.0]
                                                        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)profileDetail{
    countryName.text =[userInfo valueForKey:@"COUNTRYVALUE"];
    username.text =[userInfo valueForKey:@"USERNAME"];
    email.text =[userInfo valueForKey:@"EMAILVALUE"];
    phoneNumber.text =[userInfo valueForKey:@"PHONENO"];
    profileImage.layer.cornerRadius =  profileImage.frame.size.width / 2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 2;
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    NSURL *imageURL = [NSURL URLWithString:[userInfo valueForKey:@"IMAGEURL"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    profileImage.image = [UIImage imageWithData:imageData];

}
- (BOOL)setValidationMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    return false;
}
- (BOOL)validate{
    if (countryName.text.length == 0){
        return [self setValidationMsg:@"Please populate your Country name."];
    }else if(username.text.length ==  0){
        return [self setValidationMsg:@"Please populate your User name."];
    }else if(email.text.length ==  0){
        return [self setValidationMsg:@"Please populate your Email."];
    }else if(phoneNumber.text.length == 0) {
        return [self setValidationMsg:@"Please populate your Phone number."];
    }
    return true;
}

-(IBAction)saveButton:(id)sender{
//    if([self validate]){
    if ([self.dpOne.titleLabel.text isEqualToString:@"Public"]) {
        visibleEmail=@"0";
    }else if ([self.dpOne.titleLabel.text isEqualToString:@"Private"]){
        visibleEmail=@"1";
    }else if ([self.dpOne.titleLabel.text isEqualToString:@"Friends"]){
        visibleEmail=@"2";
    }
    if ([self.dpTwo.titleLabel.text isEqualToString:@"Public"]) {
        visiblePhone=@"0";
    }else if ([self.dpTwo.titleLabel.text isEqualToString:@"Private"]){
        visiblePhone=@"1";
    }else if ([self.dpTwo.titleLabel.text isEqualToString:@"Friends"]){
        visiblePhone=@"2";
    }
    if ([self.dpThree.titleLabel.text isEqualToString:@"Public"]) {
        visibleAddress=@"0";
    }else if ([self.dpThree.titleLabel.text isEqualToString:@"Private"]){
        visibleAddress=@"1";
    }else if ([self.dpThree.titleLabel.text isEqualToString:@"Friends"]){
        visibleAddress=@"2";
    }
        [self HUDAction];
        NSData *userUploadImage = [userInfo objectForKey:@"uploadImg"];
        UIImage *image = nil;
        NSData *imageData = nil;
        if (userUploadImage != nil){
            image =  [UIImage imageWithData:userUploadImage] ;
            image = [self resizeImage:image];
            imageData = UIImageJPEGRepresentation(image,1.0);
        }
        NSMutableDictionary *postData;
    NSString *userType=[userInfo valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"0"]){
        postData=[NSMutableDictionary dictionary];
        [postData setObject:self.individualEmail.text forKey:@"email"];
        [postData setObject:self.individualPhone.text forKey:@"mobile"];
        [postData setObject:visibleEmail forKey:@"email_visibility_state"];
        [postData setObject:visiblePhone forKey:@"mobile_visibility_state"];

    }else{
        postData=[NSMutableDictionary dictionary];
        [postData setObject:email.text forKey:@"email"];
        [postData setObject:mobile.text forKey:@"mobile"];
        [postData setObject:address1.text forKey:@"address_1"];
        [postData setObject:address2.text forKey:@"address_2"];
        if (countryIdPost==nil) {
            
        }else if(stateIdPost==nil){
            
        }else{
            [postData setObject:countryIdPost forKey:@"country_id"];
            [postData setObject:stateIdPost forKey:@"state_id"];
        }
        [postData setObject:cityIdPost forKey:@"city_id"];//hard coded here and registration
        [postData setObject:zipcode.text forKey:@"pincode"];
        [postData setObject:visibleEmail forKey:@"email_visibility_state"];
        [postData setObject:visibleAddress forKey:@"address_visibility_state"];
        [postData setObject:visiblePhone forKey:@"mobile_visibility_state"];

    }
    
    NSDictionary *passData = @{@"access_token":[userInfo valueForKey:@"TOKEN"],@"user":postData};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://192.237.241.156:9000/v1/users/update" parameters:passData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData==nil) {
            [formData appendPartWithFileData:[[NSData alloc]init]
                                        name:@"user[image]" fileName:@"NoImage" mimeType:@"image/png"];
        }else{
            [formData appendPartWithFileData:imageData  name:@"user[image]" fileName:@"ProfileImage" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"Success: %@", responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){

           // [CommonMethodClass showAlert:[responseObject valueForKey:@"message"] view:self];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:[responseObject valueForKey:@"message"]
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                               [self.navigationController popViewControllerAnimated:YES];

                                           }];
            
            [alertController addAction:cancelAction];
            [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
            UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
            [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
            [self presentViewController:alertController animated:YES completion:nil];

        }else if([error_code isEqualToString:@"400"]){
            [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
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
    
           //}

}
-(IBAction)uploadImage:(id)sender{
    [self takePhotoOrChooseFromLibrary];
}

#pragma mark : Take photo or choose the existing image from the library
- (void)takePhotoOrChooseFromLibrary
{
    sources = [[NSMutableArray alloc] init];
    NSMutableArray *buttonTitles = [[NSMutableArray alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [buttonTitles addObject:@"Take Photo"];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [buttonTitles addObject:@"Choose from Library"];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [buttonTitles addObject:@"Choose from Photo Roll"];
    }
    
    if ([sources count]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        actionSheet.tag =1;
        for (NSString *title in buttonTitles)
            [actionSheet addButtonWithTitle:title];
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = self->sources.count;
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"There are no sources available to select a photo"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark : Trigger action sheet When image picker dismiss with the button action
-(void)actionSheet:(UIActionSheet *)aSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == self->actionSheet.cancelButtonIndex){
    }else if(aSheet.tag == 1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = [[self->sources objectAtIndex:buttonIndex] integerValue];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else{
        
    }
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark : get image from the picker and push it to save or update
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [[info objectForKey:@"UIImagePickerControllerOriginalImage"]fixOrientation];
    profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 6;
    profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:1.0f] CGColor];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];

    self.profileImage.image=image;
    // Save or Update the choosen image
    [self dismissViewControllerAnimated:YES completion:nil];
   
    [userInfo setObject:UIImagePNGRepresentation(image) forKey:@"uploadImg"];
    //[userInfo setObject:registerInfo forKey:@"registerInfo"];
}

-(UIImage *)resizeImage:(UIImage *)image{
    CGRect thumbRect = CGRectMake(0.0f, 0.0f, 0.0f, .0f);
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        thumbRect = CGRectMake(0.0f, 0.0f, 396.0f, 356.0f);
    }else{
        thumbRect = CGRectMake(0.0f, 0.0f, 134.0f, 134.0f);
    }
    
    CGImageRef			imageRef = [image CGImage];
    CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    // There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
    // see Supported Pixel Formats in the Quartz 2D Programming Guide
    // Creating a Bitmap Graphics Context section
    // only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
    // and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
    // The images on input here are likely to be png or jpeg files
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    // Build a bitmap context that's the size of the thumbRect
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
                                                4 * thumbRect.size.width,	// rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                (CGBitmapInfo)alphaInfo
                                                );
   	// Draw into the context, this scales the image
    CGContextDrawImage(bitmap, thumbRect, imageRef);
    
    // Get an image from the context and a UIImage
    CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
    UIImage*	result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);	// ok if NULL
    CGImageRelease(ref);
    
    return  result;
}

-(void)tab
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    viewWidth = CGRectGetWidth(self.view.frame);
    viewHeight = CGRectGetHeight(self.view.frame);
    NSMutableArray *unselect=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"activity.png"], [UIImage imageNamed:@"request.png"], [UIImage imageNamed:@"praymenu.png"], [UIImage imageNamed:@"mine.png"],[UIImage imageNamed:@"notification.png"], nil];
    NSMutableArray *select=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"activityactive.png"], [UIImage imageNamed:@"requestactive.png"], [UIImage imageNamed:@"praymenuactive.png"],[UIImage imageNamed:@"mineactive.png"],[UIImage imageNamed:@"notificationactive.png"], nil];
    tabBar = [[HMSegmentedControl alloc] initWithSectionImages:unselect sectionSelectedImages:select];
    
    [tabBar setFrame:CGRectMake(0, viewHeight-50, viewWidth, 50)];
    tabBar.selectionIndicatorHeight = 4.0f;
    tabBar.backgroundColor = [UIColor clearColor];
    tabBar.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    tabBar.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    tabBar.selectionStyle = HMSegmentedControlSelectionStyleBox;
    tabBar.shouldAnimateUserSelection = NO;
    tabBar.verticalDividerEnabled = YES;
  
    tabBar.tag=1;
    tabBar.selectedSegmentIndex=3;
    [tabBar addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIColor *dividerColor=[CommonMethodClass pxColorWithHexValue:@"#CCF3FC"];
    tabBar.verticalDividerColor =dividerColor;
    
    
    if (isiPad) {
        tabBar.verticalDividerWidth = 1.0f;
        
    }
    else
    {
        tabBar.verticalDividerWidth = 0.5f;
        
    }
    [self.view addSubview:tabBar];
    
    
    
    
}
-(void)HeaderAction:(id)sender
{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex==0) {
    }
    else{
        MyFriendsListViewController *objs=[self.storyboard instantiateViewControllerWithIdentifier:@"MyFriendsListViewController"];
          objs.initialSelecdetIndex=[NSString stringWithFormat:@"%ld",(long)seg.selectedSegmentIndex];
        [self.navigationController pushViewController:objs animated:YES];
    }
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.tag==0) {
        NSLog(@"header tapped");
        
        if (segmentedControl.selectedSegmentIndex==0) {
            
        }
        else
        {
            MyFriendsListViewController *objs=[self.storyboard instantiateViewControllerWithIdentifier:@"MyFriendsListViewController"];
            [self.navigationController pushViewController:objs animated:YES];
        }

    }
    else
    {
        NSLog(@"tap tapped");
        
        if (segmentedControl.selectedSegmentIndex==0) {
            ActivityViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==1) {
            RequestTabViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestTabViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==2) {
            PrayerTimerViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerTimerViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==3) {
            MyProfileViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==4) {
            NotificationTabViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationTabViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        
    }
    
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    [headerBar setFrame:CGRectMake(0, 60, width, 50)];
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dropDownOne:(id)sender {
  
    if(isFirst == NO) {
        CGFloat f = 130;
        isFirst=YES;
        [ dropDown showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }else {
        isFirst=NO;
        [dropDown hideDropDown:sender];
    }
}
- (IBAction)dropDownTwo:(id)sender {
    
    if(isSecond == NO) {
        CGFloat f = 130;
        isSecond=YES;
        [ dropDown showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }else {
        isSecond=NO;
        [dropDown hideDropDown:sender];
    }
}
- (IBAction)dropDownThree:(id)sender {
    if(isThird == NO) {
        CGFloat f = 130;
        isThird=YES;
        [ dropDown showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }else {
        isThird=NO;
        [dropDown hideDropDown:sender];
    }
}

- (IBAction)editProfile:(id)sender {
    SettingViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:SVC animated:YES];
}

-(void)rel
{

}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    //[self rel];
}


- (IBAction)country:(id)sender {
}
- (IBAction)state:(id)sender {
}
- (IBAction)cityAction:(id)sender {
}
-(void)listCountry{
    [self HUDAction];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:@"http://192.237.241.156:9000/v1/address/countries"];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSDictionary *json=(NSDictionary *)responseObject;
        NSDictionary *countryList=[json valueForKey:@"message"];
        NSArray *values=[countryList valueForKey:@"countryList"];
        NSMutableDictionary *temp;
        for (NSDictionary *objTemp in values) {
            temp=[NSMutableDictionary dictionary];
            [temp setObject:[objTemp valueForKey:@"id"] forKey:@"ID"];
            [temp setObject:[objTemp valueForKey:@"name"] forKey:@"NAME"];
            [temp setObject:[objTemp valueForKey:@"sortname"] forKey:@"SHORTNAME"];
            [datasList addObject:temp];
        }
        NSLog(@"%@",datasList);
       
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
-(void)selectedString:(NSString *)text
{
    selectedStringValue=text;
    NSLog(@"phonenumberDropDownphonenumberDropDownphonenumberDropDownphonenumberDropDown-->>>%@",text);
    if (isCountry==YES) {
        isCountry=NO;
        country.text=selectedStringValue;
    }else if (isState==YES){
        isState=NO;
        state.text=selectedStringValue;
    }else if (isCity==YES){
        isCity=NO;
        city.text=selectedStringValue;
    }
    
    
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
                for (NSDictionary *objTemp in values) {
                    temp=[NSMutableDictionary dictionary];
                    [temp setObject:[objTemp valueForKey:@"id"] forKey:@"STATEID"];
                    [temp setObject:[objTemp valueForKey:@"name"] forKey:@"STATENAME"];
                    [temp setObject:[objTemp valueForKey:@"country_id"] forKey:@"COUNTRYID"];
                    [stateList addObject:temp];
                }
                NSLog(@"%@",stateList);
                [valuesList removeAllObjects];
                for (int i=0;i<[stateList count]; i++) {
                    [valuesList addObject:[[stateList valueForKey:@"STATENAME"]objectAtIndex:i]];
                }
                height=150;
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
                for (NSDictionary *objTemp in values) {
                    temp=[NSMutableDictionary dictionary];
                    [temp setObject:[objTemp valueForKey:@"id"] forKey:@"CITYID"];
                    [temp setObject:[objTemp valueForKey:@"name"] forKey:@"CITYNAME"];
                    [temp setObject:[objTemp valueForKey:@"state_id"] forKey:@"STATEID"];
                    [cityList addObject:temp];
                }
                NSLog(@"%@",cityList);
                [valuesList removeAllObjects];
                for (int i=0;i<[cityList count]; i++) {
                    [valuesList addObject:[[cityList valueForKey:@"CITYNAME"]objectAtIndex:i]];
                }
                if ([cityList count]==0) {
                    isCity=NO;
                    self.cityButton.hidden=YES;
                    [city becomeFirstResponder];
                    [self showAlert:@"City Not Found, Enter Your City"];
                 
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


@end
