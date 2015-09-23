//
//  ListRequestViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface ListRequestViewController : UIViewController<SWTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *swipeOrYes;
@property (strong, nonatomic) NSString *userProfileId;

@end
