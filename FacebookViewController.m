//
//  FacebookViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "FacebookViewController.h"
#import "SearchCell.h"
#import "CommonMethodClass.h"
@interface FacebookViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.backgroundColor=[UIColor clearColor];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    
    
    //temporary hidden
    
    [self.tableView setHidden:YES];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: @[@"public_profile",@"email", @"user_friends"]
     
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in %@",result);
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"Logged in %@", result);
                      }
                  }];
             }

         }
     }];
    
    login.loginBehavior=FBSDKLoginBehaviorWeb;  // it open inside the app using popup menu
//    [login logInWithPublishPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//            NSLog(@"Process error");
//        } else if (result.isCancelled) {
//            NSLog(@"Cancelled");
//        } else {
//            NSLog(@"Logged in");
//        }
//    }];

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
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    if (indexPath.row==0) {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        
    }
    else if(indexPath.row==2)
    {
        cell.inviteBtn.hidden=YES;
        
    }
    else if(indexPath.row==1)
    {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        [cell.inviteBtn setTitle:@"Invited" forState:UIControlStateNormal];
        [cell.inviteBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.inviteBtn layer] setBorderWidth:1.0f];
        cell.inviteBtn.backgroundColor=[UIColor clearColor];
    }
    else if(indexPath.row==3)
    {
        cell.addFriend.hidden=YES;
        cell.FollowBtn.hidden=YES;
        [cell.inviteBtn setTitle:@"Unfriend" forState:UIControlStateNormal];
        [cell.inviteBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.inviteBtn layer] setBorderWidth:1.0f];
        cell.inviteBtn.backgroundColor=[UIColor clearColor];
    }
    else if(indexPath.row==4)
    {
        cell.inviteBtn.hidden=YES;
        [cell.FollowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.FollowBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.FollowBtn layer] setBorderWidth:1.0f];
        cell.FollowBtn.backgroundColor=[UIColor clearColor];
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


@end
