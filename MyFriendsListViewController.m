//
//  MyFriendsListViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "MyFriendsListViewController.h"
#import "CommonMethodClass.h"
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "MyProfileViewController.h"
#import "Constants.h"
#import "SettingViewController.h"
#import "OthersProfileViewController.h"
#import "RequestFeedViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface MyFriendsListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UISegmentedControl *obj;
    MBProgressHUD *HUD;
    NSMutableArray *requestData;
    NSString *listFlag;
    NSString *friendButtonStatus;
    NSString *followButtonStatus;
    NSString *blockButtonStatus;
    NSString *requestButtonStatus;
    NSUserDefaults *userInfo;
}
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)settingView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;
@end

@implementation MyFriendsListViewController

-(void)drawLable
{
    if (isiPad) {
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,1024, self.naviLbl.bounds.size.height)];
    }else{
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,600, self.naviLbl.bounds.size.height)];
    }

    CALayer *layer = self.naviLbl.layer;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
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
    //
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.topShadowLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f,0.5f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
}
-(void)viewWillAppear:(BOOL)animated{
//    indexToLoad=0;
    NSLog(@"%ld",(long)[self.initialSelecdetIndex integerValue]);
    self.topBar.selectedSegmentIndex=[self.initialSelecdetIndex integerValue];
    indexToLoad=(int)[self.initialSelecdetIndex integerValue];

    if(indexToLoad == 1){
        listFlag = @"friend";
    }else if(indexToLoad == 2){
        listFlag = @"followers";
    }else if(indexToLoad == 3){
        listFlag = @"following";
    }

    [self friendListAction:listFlag];
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
    [self drawLable];
    [self topShadowLable];
    self.tableView.backgroundColor=[UIColor clearColor];
    UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#2A50AB"];
    UIColor *tintColor=[CommonMethodClass pxColorWithHexValue:@"#3D62B3"];
    
    [self.topBar setTitle:@"Public" forSegmentAtIndex:2];
    self.topBar.backgroundColor = backColor;
    self.topBar.tintColor =tintColor;
    self.topBar.layer.borderColor=[UIColor clearColor].CGColor;
    self.topBar.layer.cornerRadius = 0.0;
    self.topBar.layer.borderWidth = .0f;
    
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
//     [self.topBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Pro" size:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)friendListAction:(NSString *)flag{
    [self HUDAction];
    NSMutableURLRequest* request;
    if([flag isEqualToString:@"friend"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/get_myprofile?access_token=%@&type=1",[userInfo valueForKey:@"TOKEN"]]];
    }else if ([flag isEqualToString:@"followers"]){
       request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/get_myprofile?access_token=%@&type=2",[userInfo valueForKey:@"TOKEN"]]];
    }else if ([flag isEqualToString:@"following"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/get_myprofile?access_token=%@&type=3",[userInfo valueForKey:@"TOKEN"]]];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([successStatus isEqualToString:@"200"]) {
            requestData = [[NSMutableArray alloc] init];
            [requestData removeAllObjects];
            NSString *emailCheck;
            if([flag isEqualToString:@"friend"]){
                NSArray *data = [responseObject objectForKey:@"friends_list"];
                NSMutableDictionary *tempDic;
                for (NSMutableArray *temp in data)
                {
                    NSArray *userVisibility = [data valueForKey:@"user_visibility"];
                    tempDic=[NSMutableDictionary dictionary];
                    emailCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"email_visibility_state"]];
                    if([emailCheck isEqualToString:@"0"]){

                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                        [tempDic setObject:[temp valueForKey:@"email"] forKey:@"EMAIL"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];
                    }else{
                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                    }
                    [requestData addObject:tempDic];
                }
            }else if([flag isEqualToString:@"followers"]){
                NSArray *data = [responseObject objectForKey:@"followers_list"];
                NSMutableDictionary *tempDic;
                for (NSMutableArray *temp in data)
                {
                    NSArray *userVisibility = [data valueForKey:@"user_visibility"];
                    tempDic=[NSMutableDictionary dictionary];
                    emailCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"email_visibility_state"]];
                    if([emailCheck isEqualToString:@"0"]){
                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                        [tempDic setObject:[temp valueForKey:@"email"] forKey:@"EMAIL"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];
                    }else{
                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                    }
                    [requestData addObject:tempDic];
                }

            }else if([flag isEqualToString:@"following"]){
                NSArray *data = [responseObject objectForKey:@"following_list"];
                NSMutableDictionary *tempDic;
                for (NSMutableArray *temp in data)
                {
                    NSArray *userVisibility = [temp valueForKey:@"user_visibility"];
                    tempDic=[NSMutableDictionary dictionary];
                    emailCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"email_visibility_state"]];
                    if([emailCheck isEqualToString:@"0"]){
                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];

                    }else{
                        [tempDic setObject:[temp valueForKey:@"id"] forKey:@"ID"];
                        [tempDic setObject:[temp valueForKey:@"is_friend"] forKey:@"ISFRIEND"];
                        [tempDic setObject:[temp valueForKey:@"is_follow"] forKey:@"ISFOLLOW"];
                        [tempDic setObject:[temp valueForKey:@"is_block"] forKey:@"ISBLOCK"];
                        [tempDic setObject:[temp valueForKey:@"is_friend_request_sent"] forKey:@"ISFRIENDREQUEST"];
                        [tempDic setObject:[temp valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [tempDic setObject:[temp valueForKey:@"last_name"] forKey:@"LASTNAME"];
                        [tempDic setObject:[temp valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                    }
                    [requestData addObject:tempDic];
                }

            }
            [self.tableView reloadData];
        }else if([errorState isEqualToString:@"400"]){
            [requestData removeAllObjects];
            [self.tableView reloadData];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:@"No result found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];

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
        }    }];
    [op start];

}
- (void)allFriendAction:(id)sender{
    // Do the search...
    UIButton *button=(UIButton *)sender;
    int tid=(int) button.tag;
    [self HUDAction];
    NSString *friendID = [NSString stringWithFormat:@"%@",[[requestData valueForKey:@"ID"]objectAtIndex:tid]];
    NSString *titleName = button.titleLabel.text;
    NSMutableURLRequest* request;
    if ([titleName isEqualToString:@"Follow"]){
        NSDictionary *passData = @{@"access_token":[userInfo valueForKey:@"TOKEN"],@"friend_id":friendID};
        request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/followFriend" dictornay:passData];
    }else if ([titleName isEqualToString:@"Unfollow"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"1"]];
    }else if ([titleName isEqualToString:@"Unfriend"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"0"]];
    }else if ([titleName isEqualToString:@"Unblock"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"2"]];
    }else if ([titleName isEqualToString:@"Block"]){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/userAction?access_token=%@&user_id=%@&type=%d",[userInfo valueForKey:@"TOKEN"],friendID,2]];
    }else if ([titleName isEqualToString:@"Add Friend"]){
        NSDictionary *passData = @{@"access_token":[userInfo valueForKey:@"TOKEN"],@"friend_id":friendID};
        request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/addFriend" dictornay:passData];
    }

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *sucessStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        
        if ([sucessStatus isEqualToString:@"200"]) {
            if ([titleName isEqualToString:@"Follow"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User follow sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if ([titleName isEqualToString:@"Unfollow"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unfollow sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if ([titleName isEqualToString:@"Unfriend"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unfriend sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if ([titleName isEqualToString:@"Block"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User blocked sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if ([titleName isEqualToString:@"Unblock"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unblocked sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if ([titleName isEqualToString:@"Add Friend"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"Friend added sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            
        }else if([errorState isEqualToString:@"400"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:@"No data found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        //[requestData removeAllObjects];
        [self friendListAction:listFlag];
        [self.tableView reloadData];
        
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
        }    }];
    [op start];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendsCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    UILabel *lineLbl=[[UILabel alloc]init];
    [lineLbl setFrame:CGRectMake(0, 131, self.tableView.frame.size.width,0.5)];
    [lineLbl setBackgroundColor:sepColor];
    [cell.contentView addSubview:lineLbl];
    
    if([[[requestData objectAtIndex:indexPath.row]valueForKey:@"IMAGEURL"]  isEqual: @""]){
        
    }else{
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2;
        cell.userImage.layer.masksToBounds = true;
        cell.userImage.clipsToBounds = true;
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];

        NSURL *imageURL = [NSURL URLWithString:[[requestData objectAtIndex:indexPath.row]valueForKey:@"IMAGEURL"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        cell.userImage.image = [UIImage imageWithData:imageData];
    }

    NSString *username = [NSString stringWithFormat:@"%@%@%@",[[requestData objectAtIndex:indexPath.row]valueForKey:@"FIRSTNAME"],@" ",[[requestData objectAtIndex:indexPath.row]valueForKey:@"LASTNAME"]];
    cell.nameLbl.text = username;
    cell.emailLbl.text = [[requestData objectAtIndex:indexPath.row]valueForKey:@"EMAIL"];
    friendButtonStatus = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row]valueForKey:@"ISFRIEND"]];
    followButtonStatus = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row]valueForKey:@"ISFOLLOW"]];
    blockButtonStatus = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row]valueForKey:@"ISBLOCK"]];
    requestButtonStatus = [NSString stringWithFormat:@"%@",[[requestData objectAtIndex:indexPath.row]valueForKey:@"ISFRIENDREQUEST"]];

    if([friendButtonStatus isEqualToString:@"1"]){
        [cell.buttonOne setTitle:@"Unfriend" forState:UIControlStateNormal];
        [cell.buttonOne addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonOne setBackgroundColor:[UIColor clearColor]];
        [cell.buttonOne.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.buttonOne layer] setBorderWidth:1.0f];
        cell.buttonOne.tag =indexPath.row;
    }else if([requestButtonStatus isEqualToString:@"1"] && [friendButtonStatus isEqualToString:@"0"]){
        [cell.buttonOne setTitle:@"Friend request send" forState:UIControlStateNormal];
        [cell.buttonOne setBackgroundColor:[UIColor clearColor]];
        [cell.buttonOne.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.buttonOne layer] setBorderWidth:1.0f];
        cell.buttonOne.tag =indexPath.row;
    }else{
        [cell.buttonOne setTitle:@"Add Friend" forState:UIControlStateNormal];
        [cell.buttonOne addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *col=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
        [cell.buttonOne setBackgroundColor:col];
        [cell.buttonOne.layer setBorderColor:[UIColor clearColor].CGColor];
        [[cell.buttonOne layer] setBorderWidth:0.0f];
        cell.buttonOne.tag =indexPath.row;
    }

    if([followButtonStatus isEqualToString:@"1"]){
        [cell.buttonTwo setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.buttonTwo addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonTwo setBackgroundColor:[UIColor clearColor]];
        [cell.buttonTwo.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.buttonTwo layer] setBorderWidth:1.0f];
        cell.buttonTwo.tag =indexPath.row;
    }else{
        [cell.buttonTwo setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.buttonTwo addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *col=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
        [cell.buttonTwo setBackgroundColor:col];
        [cell.buttonTwo.layer setBorderColor:[UIColor clearColor].CGColor];
        [[cell.buttonTwo layer] setBorderWidth:1.0f];
        cell.buttonTwo.tag =indexPath.row;
    }
        
    if([blockButtonStatus isEqualToString:@"1"]){
        [cell.buttonThree setTitle:@"Unblock" forState:UIControlStateNormal];
        [cell.buttonThree addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonThree setBackgroundColor:[UIColor clearColor]];
        [cell.buttonThree.layer setBorderColor:[UIColor whiteColor].CGColor];
        [[cell.buttonThree layer] setBorderWidth:1.0f];
        cell.buttonThree.tag =indexPath.row;
    }else{
        [cell.buttonThree setTitle:@"Block" forState:UIControlStateNormal];
        [cell.buttonThree addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *col=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
        [cell.buttonThree setBackgroundColor:col];
        [cell.buttonThree.layer setBorderColor:[UIColor clearColor].CGColor];
        [[cell.buttonThree layer] setBorderWidth:0.0f];
        cell.buttonThree.tag =indexPath.row;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OthersProfileViewController *OVC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersProfileViewController"];
    OVC.userProfileId=[[requestData valueForKey:@"ID"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:OVC animated:YES];
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
    tabBar.verticalDividerColor = [UIColor whiteColor];
    tabBar.verticalDividerWidth = 1.0f;
    tabBar.tag=1;
    tabBar.selectedSegmentIndex=3;
    [tabBar addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIColor *dividerColor=[CommonMethodClass pxColorWithHexValue:@"#CCF3FC"];
    tabBar.verticalDividerColor =dividerColor;
    
    if (isiPad) {
        tabBar.verticalDividerWidth = 1.0f;
    }else{
        tabBar.verticalDividerWidth = 0.5f;
    }
    [self.view addSubview:tabBar];
}
-(void)HeaderAction:(id)sender
{
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    
    if (seg.selectedSegmentIndex==0) {
        MyProfileViewController *objs=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        [self.navigationController pushViewController:objs animated:YES];
    }else{
        indexToLoad=(int)seg.selectedSegmentIndex;
        if(indexToLoad == 1){
            listFlag = @"friend";
        }else if(indexToLoad == 2){
            listFlag = @"followers";
        }else if(indexToLoad == 3){
            listFlag = @"following";
        }
        [self friendListAction:listFlag];
        [self.tableView reloadData];
    }
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.tag==0) {
        NSLog(@"header tapped");
        if (segmentedControl.selectedSegmentIndex==0) {
            MyProfileViewController *objs=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            [self.navigationController pushViewController:objs animated:YES];
        }
        else
        {
            indexToLoad=(int)segmentedControl.selectedSegmentIndex;
            [self.tableView reloadData];
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    //[self.tableView setFrame:CGRectMake(0, 62, width, viewHeight-50)];
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
}

- (IBAction)settingView:(id)sender {
    
    SettingViewController *objs=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:objs animated:YES];
}
@end
