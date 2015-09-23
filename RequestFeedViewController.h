//
//  RequestFeedViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 18/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "NSDate+TimeAgo.h"
@interface RequestFeedViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *obj;
}

@end
