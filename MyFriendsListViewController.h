//
//  MyFriendsListViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "FriendsCell.h"
@interface MyFriendsListViewController : UIViewController
{
    HMSegmentedControl *headerBar ;
    HMSegmentedControl *tabBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
    
    
    
    
    int indexToLoad;
}
@property (weak, nonatomic) IBOutlet UILabel *topShadowLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSString *initialSelecdetIndex;


@end
