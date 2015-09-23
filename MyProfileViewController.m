//
//  MyProfileViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//
#import "Constants.h"
#import "MyProfileViewController.h"
#import "ProfileCell.h"
#import "CommonMethodClass.h"
#import "SettingViewController.h"
#import "SwitchAccountViewController.h"
#import "EditProfileViewController.h"
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "RequestFeedViewController.h"
#import "MBProgressHUD.h"
#import "ListRequestViewController.h"
#import "MyFriendsListViewController.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface MyProfileViewController ()
{
   UISegmentedControl *obj;
   MBProgressHUD *HUD;
   NSMutableArray *profileData;
   NSUserDefaults *userInfo;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)settingView:(id)sender;
- (IBAction)switchAccount:(id)sender;
- (IBAction)editProfile:(id)sender;
- (IBAction)RequestList:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *addressImage;

@end

@implementation MyProfileViewController
@synthesize profileImage;
-(void)drawLable
{
    if (isiPad) {
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,1024, self.naviLbl.bounds.size.height)];
    }else{
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,600, self.naviLbl.bounds.size.height)];
    }

    CALayer *layer = self.naviLbl.layer;
    //
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
    
}
-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}

-(void)topShadowLable
{
    if (isiPad) {
        [self.topShadowLbl setFrame:CGRectMake(self.topShadowLbl.bounds.origin.x, self.topShadowLbl.bounds.origin.y,1024, self.topShadowLbl.bounds.size.height)];
    }
    else{
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

-(void)viewWillAppear:(BOOL)animated{
    [self profileDetail];
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
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
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];

    [self drawLable];
    [self topShadowLable];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.scrollView.contentSize=CGSizeMake(0, 700);

    UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#2A50AB"];
    UIColor *tintColor=[CommonMethodClass pxColorWithHexValue:@"#3D62B3"];
    
    self.topBar.backgroundColor = backColor;
    self.topBar.tintColor =tintColor;
    self.topBar.layer.borderColor=[UIColor clearColor].CGColor;
    self.topBar.layer.cornerRadius = 0.0;
    self.topBar.layer.borderWidth = .0f;
    self.topBar.selectedSegmentIndex=0;
    self.topBar.selectedSegmentIndex=0;
    [self.topBar setTitle:@"Public" forSegmentAtIndex:2];

    UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#A1CD46"];
     //UIColor *unselectedFont=[CommonMethodClass pxColorWithHexValue:@"#B6C6E3"];
    UIColor *unselectedFont=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[unselectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    
    NSDictionary *attributess = [NSDictionary dictionaryWithObjects:@[selectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributess
                               forState:UIControlStateSelected];
    [self.topBar addTarget:self action:@selector(HeaderAction:) forControlEvents:UIControlEventValueChanged];
//            [self.topBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Pro" size:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    //[self.tableView setFrame:CGRectMake(0, 62, width, viewHeight-50)];
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
}
-(void)profileDetail{
    [self HUDAction];
    NSString *userType=[userInfo valueForKey:@"USERTYPE"];
    if ([userType isEqualToString:@"0"]) {
        self.addressImage.hidden=YES;
    }else{
        self.addressImage.hidden=NO;
    }
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/get_myprofile?access_token=%@&type=%@",[userInfo valueForKey:@"TOKEN"],userType]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSDictionary *profileDatas=[NSDictionary dictionary];
        if ([successStatus isEqualToString:@"200"]) {
            profileDatas=responseObject;
            [userInfo setObject:[NSKeyedArchiver archivedDataWithRootObject:profileDatas] forKey:@"USERDETAILS"];
            NSDictionary *arrayOfdata = [responseObject valueForKey:@"my_profile_info"];
            NSDictionary *countryData = [arrayOfdata valueForKey:@"country"];
            NSDictionary *stateData = [arrayOfdata valueForKey:@"state"];
            NSDictionary *cityData = [arrayOfdata valueForKey:@"city"];

            name.text = [NSString stringWithFormat:@"%@%@%@",[arrayOfdata valueForKey:@"first_name"],@" ",[arrayOfdata valueForKey:@"last_name"]];
            email.text = [arrayOfdata valueForKey:@"email"];
            phonenumber.text = [arrayOfdata valueForKey:@"mobile"];
            NSString *userImage=[NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"image_url"]];
            if ([userImage isEqualToString:@""]) {
                
            }else{
                profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
                profileImage.layer.masksToBounds = YES;
                profileImage.layer.borderWidth = 6;
                profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:1.0f] CGColor];
                [[SDImageCache sharedImageCache]clearMemory];
                [[SDImageCache sharedImageCache]clearDisk];
                NSURL *URL2 = [NSURL URLWithString:[arrayOfdata valueForKey:@"image_url"]];
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

//            if([[arrayOfdata valueForKey:@"image_url"]  isEqual: @""]){
//                
//            }else{
//                profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
//                profileImage.layer.masksToBounds = YES;
//                profileImage.layer.borderWidth = 6;
//                profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:1.0f] CGColor];
//                [[SDImageCache sharedImageCache]clearMemory];
//                [[SDImageCache sharedImageCache]clearDisk];
//
//                 NSURL *imageURL = [NSURL URLWithString:[arrayOfdata valueForKey:@"image_url"]];
//                 NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                 profileImage.image = [UIImage imageWithData:imageData];
//            }

            [userInfo setObject:[NSString stringWithFormat:@"%@%@%@",[arrayOfdata valueForKey:@"first_name"],@" ",[arrayOfdata valueForKey:@"last_name"]] forKey:@"USERNAMEPROILE"];
            [userInfo setObject:[arrayOfdata valueForKey:@"mobile"] forKey:@"PHONENO"];
            [userInfo setObject:[arrayOfdata valueForKey:@"email"] forKey:@"EMAILVALUE"];
            [userInfo setObject:[arrayOfdata valueForKey:@"image_url"] forKey:@"IMAGEURL"];
            [userInfo setObject:[arrayOfdata valueForKey:@"id"] forKey:@"USERID"];
            NSString *addressValue;
            NSString *stateValue;
            NSString *pincodeValue;
            NSString *countryValue;
            if([arrayOfdata valueForKey:@"address_1"] == [NSNull null] && [arrayOfdata valueForKey:@"address_2"] == [NSNull null]){
                addressValue = @"";
            }else if ([arrayOfdata valueForKey:@"address_1"] == [NSNull null]){
                addressValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"address_2"]];
            }else if ([arrayOfdata valueForKey:@"address_2"] == [NSNull null]){
                addressValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"address_1"]];
            }else{
                addressValue = [NSString stringWithFormat:@"%@%@%@",[arrayOfdata valueForKey:@"address_1"],@",",[arrayOfdata valueForKey:@"address_2"]];
            }
            
            if([arrayOfdata valueForKey:@"state"] == [NSNull null] && [arrayOfdata valueForKey:@"city"] == [NSNull null]){
                stateValue = @"";
            }else if ([arrayOfdata valueForKey:@"state"] == [NSNull null]){
                stateValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"city"]];
            }else if ([arrayOfdata valueForKey:@"city"] == [NSNull null]){
                stateValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"state"]];
            }else{
                stateValue = [NSString stringWithFormat:@"%@%@%@",[stateData valueForKey:@"name"],@",",[cityData valueForKey:@"name"]];
            }
            
            if([arrayOfdata valueForKey:@"pincode"] == [NSNull null]){
                pincodeValue = @"";
            }else{
                pincodeValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"pincode"]];
            }
            
            if([arrayOfdata valueForKey:@"country"] == [NSNull null]){
                countryValue = @"";
            }else{
                countryValue = [NSString stringWithFormat:@"%@",[countryData valueForKey:@"name"]];
            }
            
            country.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",addressValue,stateValue,pincodeValue,@" ",countryValue];
            [userInfo setObject:[NSString stringWithFormat:@"%@%@%@%@",addressValue,stateValue,pincodeValue,countryValue] forKey:@"COUNTRYVALUE"];

        }else if([errorState isEqualToString:@"400"]){
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
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
   
    tabBar.selectedSegmentIndex=3;
    tabBar.tag=1;
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
            RequestFeedViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestFeedViewController"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingView:(id)sender {
    
    SettingViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)switchAccount:(id)sender {
    SwitchAccountViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SwitchAccountViewController"];
    
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)editProfile:(id)sender {
    
    EditProfileViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)RequestList:(id)sender {
    
    ListRequestViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ListRequestViewController"];
    SVC.userProfileId = [userInfo valueForKey:@"USERID"];
    SVC.swipeOrYes=@"no";
    [self.navigationController pushViewController:SVC animated:YES];
}
@end
