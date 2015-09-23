//
//  SettingViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 17/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingsCell.h"
#import "SocialConnectionViewController.h"
#import "TestViewController.h"
#import "CommonMethodClass.h"
#import "TermsAndConditionViewController.h"
#import "ViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "ActivityViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *HUD;
    NSUserDefaults *userInfo;
}
@property (weak, nonatomic) IBOutlet UIImageView *back;
- (IBAction)backAction:(id)sender;

@end

@implementation SettingViewController
@synthesize loadValue;

-(void)drawView{
    if (isiPad) {
        
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }
    else
    {
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,600, self.naviView.bounds.size.height)];
        
    }
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviView.bounds];
    self.naviView.layer.masksToBounds = NO;
    self.naviView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.naviView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.naviView.layer.shadowOpacity = 0.3f;
    self.naviView.layer.shadowPath = shadowPath.CGPath;
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
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    loadValue=[[NSArray alloc]initWithObjects:@"Notifications",@"Find Friends",@"Social Connections",@"Email Digest",@"Edit Profile",@"Change Password",@"Blocked Users",@"Terms/Policies",@"Logout",nil];
 
    self.tableView.backgroundColor=[UIColor clearColor];
    self.navigationController.navigationBarHidden=YES;
    [self drawView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return loadValue.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingsCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.ttitleLbl.text=self.loadValue[indexPath.row];

    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
   
        
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0,58, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
        
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
        NotificationViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        [self.navigationController pushViewController:NVC animated:YES];
        
        
    }
    else if (indexPath.row==1) {
      TestViewController   *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
        NVC.hideSkip=@"yes";
        [self.navigationController pushViewController:NVC animated:YES];

        
    }
    else if (indexPath.row==2) {
        SocialConnectionViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialConnectionViewController"];
        [self.navigationController pushViewController:NVC animated:YES];

        
    }

    else if (indexPath.row==3) {
        EmailDigestViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EmailDigestViewController"];
        [self.navigationController pushViewController:NVC animated:YES];

        
    }

    else if (indexPath.row==4) {
        EditProfileViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        [self.navigationController pushViewController:NVC animated:YES];

        
    }

    else if (indexPath.row==5) {
        
        ChangePasswordViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        [self.navigationController pushViewController:NVC animated:YES];

        
    }

    else if (indexPath.row==6) {
        BlockedUserViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"BlockedUserViewController"];
        [self.navigationController pushViewController:NVC animated:YES];

    }

    else if (indexPath.row==7) {
        TermsAndConditionViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
        [self.navigationController pushViewController:NVC animated:YES];
        
    }

    else if (indexPath.row==8) {
        [self logoutAction];
    }

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [self.tableView reloadData];
    
}
-(void)loginAction{
    ViewController *loginController=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:loginController animated:YES];
}

-(void)activityAction{
    // Generate content view to present
    ActivityViewController *activityController=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    [self.navigationController pushViewController:activityController animated:YES];
}
-(void)logoutAction{
    [self HUDAction];
    
    NSMutableURLRequest* request=[CustomAFNetworking deleteMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/users/logout?access_token=%@",[userInfo valueForKey:@"TOKEN"]]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *tokenValue=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"token"]];
        NSString *userTypeValue=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"user_type_id"]];

        
        if ([successStatus isEqualToString:@"200"]) {
           [self loginAction];
        }else if([successStatus isEqualToString:@"201"]){
            [userInfo setObject:tokenValue forKey:@"TOKEN"];
            [userInfo setObject:userTypeValue forKey:@"USERTYPE"];
            [self activityAction];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet){
            // if we can identify the error, we can present a more precise message to the user.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                            message:@"Sorry, no Internet connectivity detected. Please reconnect and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    [op start];

//    ViewController *NVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    [self.navigationController pushViewController:NVC animated:YES];

}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
