//
//  PrayCompletedViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 22/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrayCompletedViewController : UIViewController
@property(nonatomic,strong)NSString *timerString;
@property(nonatomic,strong)NSString *totalRequest;
@property(nonatomic,strong)NSString *totalPrayer;
@property(nonatomic,strong)NSMutableArray *datas;


@property(nonatomic,strong)NSString *totalPrayedTime;

@end
