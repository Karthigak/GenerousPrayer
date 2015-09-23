//
//  PrayMoreViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 22/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerScreen.h"
#import "NIDropDown.h"
#import "LGActionSheet.h"
@interface PrayMoreViewController : UIViewController<LGActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)start:(id)sender;


@property(nonatomic,strong)NSString *remainingTime;
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)NSString *totalPrayer;
@property(nonatomic,strong)NSString *count;


@property(nonatomic,strong)NSString *prayedTimers;


@end
