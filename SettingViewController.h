//
//  SettingViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 17/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NotificationViewController.h"
#import "SocialConnectionViewController.h"
#import "EmailDigestViewController.h"
#import "EditProfileViewController.h"
#import "ChangePasswordViewController.h"
#import "BlockedUserViewController.h"


@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *loadValue;
@property (weak, nonatomic) IBOutlet UIView *naviView;

@end
