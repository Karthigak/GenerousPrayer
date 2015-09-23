//
//  ActivityViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "HMSegmentedControl.h"
#import "ActivityCell.h"



#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
@interface ActivityViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HMSegmentedControl *tabBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
