//
//  PrayCompletedViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 22/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "PrayCompletedViewController.h"
#import "PrayMoreViewController.h"
#import "PrayerTimerViewController.h"
@interface PrayCompletedViewController ()
@property (strong, nonatomic) IBOutlet UILabel *requests;
@property (strong, nonatomic) IBOutlet UILabel *timerLbl;
@property (strong, nonatomic) IBOutlet UILabel *prayedTimer;
- (IBAction)end:(id)sender;
- (IBAction)prayMore:(id)sender;

@end

@implementation PrayCompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.timerLbl.text=self.timerString;
    self.requests.text=[NSString stringWithFormat:@"%@/%@ requests",self.totalPrayer,self.totalRequest];
    self.prayedTimer.text=self.totalPrayedTime;
}

- (IBAction)end:(id)sender {
    PrayerTimerViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerTimerViewController"];
    
    [self.navigationController pushViewController:obj animated:YES];}

- (IBAction)prayMore:(id)sender {
    
    PrayMoreViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayMoreViewController"];
    obj.datas=self.datas;
    obj.remainingTime=self.timerLbl.text;
    obj.totalPrayer=self.requests.text;
    obj.prayedTimers=self.prayedTimer.text;
    [self.navigationController pushViewController:obj animated:YES];
    
}
@end
