//
//  OthersProfileViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "OthersProfileViewController.h"
#import "ListRequestViewController.h"
#import "Constants.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "CommonMethodClass.h"
@interface OthersProfileViewController (){
    MBProgressHUD *HUD;
    NSMutableArray *profileData;
    NSString *friendIdValue;
    NSUserDefaults *userInfo;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)RequestList:(id)sender;
- (IBAction)settingView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)back:(id)sender;

@end

@implementation OthersProfileViewController
@synthesize profileImage,userProfileId,friendButton,followingButton,blockButton;
-(void)drawBorder
{
    if (isiPad) {
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }else{
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
    self.scrollView.contentSize=CGSizeMake(0, 800);
    [self profileDetail];
    [self drawBorder];
    // Do any additional setup after loading the view.
}

- (void)allFriendAction:(id)sender{
    // Do the search...
    UIButton *button=(UIButton *)sender;
    int tid=(int) button.tag;
    [self HUDAction];
    NSString *friendID = friendIdValue;
    [HUD hide:YES];
    NSMutableURLRequest* request;
    if (tid == 3){
        NSDictionary *passData = @{@"access_token":[userInfo valueForKey:@"TOKEN"],@"friend_id":friendID};
        request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/followFriend" dictornay:passData];
    }else if (tid == 4){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"1"]];
    }else if (tid == 2){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"0"]];
    }else if (tid == 6){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/unfollowFriend?access_token=%@&friend_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],friendID,@"2"]];
    }else if (tid == 5){
        request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/userAction?access_token=%@&user_id=%@&type=%d",[userInfo valueForKey:@"TOKEN"],friendID,2]];
    }else if (tid == 1){
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
            if (tid == 3){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User follow sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if (tid == 4){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unfollow sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if (tid == 2){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unfriend sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if (tid == 5){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User blocked sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if (tid == 6){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"User unblocked sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else if (tid == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                                message:@"Friend added sucessfully"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            [self profileDetail];
        }else if([errorState isEqualToString:@"400"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:@"No data found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
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
        }
        }];
    [op start];
}

-(void)profileDetail{
    [self HUDAction];
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/get_userprofile?access_token=%@&user_profile_id=%@",[userInfo valueForKey:@"TOKEN"],userProfileId]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        
        if ([successStatus isEqualToString:@"200"]) {
            profileData=[[NSMutableArray alloc]init];
            NSDictionary *arrayOfdata = [responseObject valueForKey:@"user_profile_info"];
            NSDictionary *countryData = [arrayOfdata valueForKey:@"country"];
            NSDictionary *stateData = [arrayOfdata valueForKey:@"state"];
            NSDictionary *cityData = [arrayOfdata valueForKey:@"city"];
            headerUsername.text = [NSString stringWithFormat:@"%@%@%@%@%@",[arrayOfdata valueForKey:@"first_name"],@" ",[arrayOfdata valueForKey:@"last_name"],@"",@"Profile"];

            friendIdValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"id"]];
            name.text = [NSString stringWithFormat:@"%@%@%@",[arrayOfdata valueForKey:@"first_name"],@" ",[arrayOfdata valueForKey:@"last_name"]];
            NSString *isFriend = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"is_friend"]];
            NSString *isFollow = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"is_follow"]];
            NSString *isBlock = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"is_block"]];
            NSString *isFriendRequest = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"is_friend_request_sent"]];
            
            NSArray *userVisibility = [arrayOfdata valueForKey:@"user_visibility"];
            NSString *emailCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"email_visibility_state"]];
            NSString *addressCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"address_visibility_state"]];
            NSString *mobileCheck = [NSString stringWithFormat:@"%@",[userVisibility valueForKey:@"mobile_visibility_state"]];

            if([emailCheck isEqualToString:@"0"]){
                email.text = [arrayOfdata valueForKey:@"email"];
            }else{
                email.text = @"Restricted";
            }
            if([addressCheck isEqualToString:@"0"]){
                NSString *addressValue;
                NSString *stateValue;
                NSString *pincodeValue;
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
                    stateValue = [NSString stringWithFormat:@"%@",[cityData valueForKey:@"name"]];
                }else if ([arrayOfdata valueForKey:@"city"] == [NSNull null]){
                    stateValue = [NSString stringWithFormat:@"%@",[stateData valueForKey:@"name"]];
                }else{
                    stateValue = [NSString stringWithFormat:@"%@%@%@",[stateData valueForKey:@"name"],@",",[cityData valueForKey:@"name"]];
                }
                
                if([arrayOfdata valueForKey:@"pincode"] == [NSNull null]){
                    pincodeValue = @"";
                }else{
                    pincodeValue = [NSString stringWithFormat:@"%@",[arrayOfdata valueForKey:@"pincode"]];
                }
                
                address.text = [NSString stringWithFormat:@"%@%@%@%@%@",addressValue,stateValue,pincodeValue,@",",[countryData valueForKey:@"name"]];
            }else{
                address.text = @"Restricted";
            }
            if([mobileCheck isEqualToString:@"0"]){
                phonenumber.text = [arrayOfdata valueForKey:@"mobile"];
            }else{
                phonenumber.text = @"Restricted";
            }

            if([isFriend isEqualToString:@"1"]){
                friendLabel.text = @"Friend";
                [friendButton setImage:[UIImage imageNamed:@"friendactive.png"] forState:UIControlStateNormal];
                [friendButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                friendButton.tag = 2;

            }else if([isFriendRequest isEqualToString:@"1"] && [isFriend isEqualToString:@"0"]){
                friendLabel.text = @"Friend request send";
                [friendButton setImage:[UIImage imageNamed:@"friendactive.png"] forState:UIControlStateNormal];
            }else{
                friendLabel.text = @"Add Friend";
                [friendButton setImage:[UIImage imageNamed:@"addfriend.png"] forState:UIControlStateNormal];
                [friendButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                friendButton.tag = 1;

            }
            if([isFollow isEqualToString:@"1"]){
                followingLabel.text = @"Following";
                [followingButton setImage:[UIImage imageNamed:@"following.png"] forState:UIControlStateNormal];
                [followingButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                 followingButton.tag = 4;
            }else{
                followingLabel.text = @"Follow";
                [followingButton setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                [followingButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                followingButton.tag = 3;
            }
            if([isBlock isEqualToString:@"1"]){
                blockLabel.text = @"UnBlock";
                [blockButton setImage:[UIImage imageNamed:@"unblock.png"] forState:UIControlStateNormal];
                [blockButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                blockButton.tag = 6;
            }else{
                blockLabel.text = @"block";
                [blockButton setImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
                [blockButton addTarget:self action:@selector(allFriendAction:) forControlEvents:UIControlEventTouchUpInside];
                blockButton.tag = 5;
            }

            if([[arrayOfdata valueForKey:@"image_url"]  isEqual: @""]){
                
            }else{
                profileImage.layer.cornerRadius =  profileImage.frame.size.width / 4;
                profileImage.layer.masksToBounds = YES;
                profileImage.layer.borderWidth = 6;
                profileImage.layer.borderColor = [[UIColor colorWithRed:18.0f green:155.0f blue:186.0f alpha:6.0f] CGColor];
                
                [[SDImageCache sharedImageCache]clearMemory];
                [[SDImageCache sharedImageCache]clearDisk];

                NSURL *imageURL = [NSURL URLWithString:[arrayOfdata valueForKey:@"image_url"]];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                profileImage.image = [UIImage imageWithData:imageData];
            }
            
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RequestList:(id)sender {
    ListRequestViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ListRequestViewController"];
    obj.userProfileId = userProfileId;
    obj.swipeOrYes=@"yes";
    [self.navigationController pushViewController:obj animated:YES];
}

- (IBAction)settingView:(id)sender {
    SettingViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:obj animated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
