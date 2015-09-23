//
//  NotificationTabViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "HMSegmentedControl.h"
#import "ActivityCell.h"
@interface NotificationTabViewController : UIViewController
<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HMSegmentedControl *tabBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;
@end
