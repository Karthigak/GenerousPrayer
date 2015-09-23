//
//  PrayMoreViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 22/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "PrayMoreViewController.h"
#import "PrayerTimerViewController.h"
#import "TimerScreen.h"
#import "RMActionController.h"
#import "RMDateSelectionViewController.h"
#import "CommonMethodClass.h"
@interface PrayMoreViewController ()<NIDropDownDelegate>{
    NIDropDown *dropDown;
    BOOL issecondsClicked;
    NSString *selectedString;
    NSString *moreTime;
    RMDateSelectionViewController *dateSelectionController;

}
@property (strong, nonatomic) IBOutlet UIButton *buttonBetweenTime;
- (IBAction)end:(id)sender;
- (IBAction)selectBetween:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonMoreTime;
- (IBAction)selectMoreTime:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *requests;
@property (strong, nonatomic) IBOutlet UILabel *timerLbl;
@property (strong, nonatomic) IBOutlet UILabel *prayedTimer;
@end

@implementation PrayMoreViewController
- (IBAction)start:(id)sender{
     if ([CommonMethodClass isEmpty:self.buttonMoreTime.titleLabel.text ]){
        [CommonMethodClass showAlert:@"Select your prayer time" view:self];
    }else if ([CommonMethodClass isEmpty:self.buttonBetweenTime.titleLabel.text ]){
        [CommonMethodClass showAlert:@"Select your prayer time between duration" view:self];
    }else if ([self.buttonMoreTime.titleLabel.text isEqualToString:@"00:00:00"]){
        [CommonMethodClass showAlert:@"Atleast select five minutes" view:self];
    }else{
    NSArray *extraPrayTimer=[moreTime componentsSeparatedByString:@":"];
    int hour=[[extraPrayTimer objectAtIndex:0]intValue];
    int mins=[[extraPrayTimer objectAtIndex:1]intValue];
    int seconds=[[extraPrayTimer objectAtIndex:2]intValue];
    NSArray *remainingPrayedTime=[self.remainingTime componentsSeparatedByString:@":"];
    int hours=[[remainingPrayedTime objectAtIndex:0]intValue];
    int minss=[[remainingPrayedTime objectAtIndex:1]intValue];
    int secondss=[[remainingPrayedTime objectAtIndex:2]intValue];
    hour=hour+hours;
    mins=mins+minss;
    seconds=seconds+secondss;
    NSString *temp=[NSString stringWithFormat:@"%d:%d:%d",hour,mins,seconds];
    TimerScreen *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"TimerScreen"];
    obj.totalPrayTimer=temp;
    obj.betweenPrayer=self.buttonBetweenTime.titleLabel.text;
    obj.datas=self.datas;
    [self.navigationController pushViewController:obj animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dropDown = [[NIDropDown alloc]init];
    dropDown.delegate = self;
    self.scrollView.contentSize=CGSizeMake(0, 1000);

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.timerLbl.text=self.remainingTime;
    self.requests.text=self.totalPrayer;
    self.prayedTimer.text=self.prayedTimers;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)end:(id)sender {
    PrayerTimerViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerTimerViewController"];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (IBAction)selectBetween:(id)sender {
    NSArray *temp;
    
    temp = [NSArray arrayWithObjects:@"30 Secs", @"45 Secs", @"1 mins",@"1.15 mins",@"1.30 mins",@"1.45 mins",@"2 mins",@"3 mins", @"4 mins",@"5 mins",nil];
    if(issecondsClicked==NO) {
        CGFloat f = 150;
        [dropDown showDropDown:sender :&f :temp :nil :@"up"];
        issecondsClicked=YES;
    }
    else {
        [dropDown hideDropDown:sender];
        issecondsClicked=NO;
        
    }

}
-(void)selectedString:(NSString *)text
{
    selectedString=text;
    
    
}
-(void)selectedIndex:(int)index{
    }

- (IBAction)selectMoreTime:(id)sender {
    //[self datePicker];
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    RMAction *selectAction = [RMAction actionWithTitle:@"Select Time" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@",dateSelectionController.datePicker.date);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
//        NSString *formatedDate = [dateFormatter stringFromDate:dateSelectionController.datePicker.date];
        moreTime= [dateFormatter stringFromDate:dateSelectionController.datePicker.date];
        [self.buttonMoreTime setTitle:[NSString stringWithFormat:@"%@",moreTime] forState:UIControlStateNormal];
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Select Time";
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeTime;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"da_DK"];
    [dateSelectionController.datePicker setLocale:locale];
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self.view;
        
    }
    dateSelectionController.disableBlurEffects = YES;
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}
-(void)selectedDateOfBirth:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
     moreTime= [dateFormatter stringFromDate:datePicker.date];
    [self.buttonMoreTime setTitle:[NSString stringWithFormat:@"%@",moreTime] forState:UIControlStateNormal];
}
-(void)datePicker
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.frame = CGRectMake(0.f, 0.f, datePicker.frame.size.width, 100.f);
    datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
    [datePicker addTarget:self action:@selector(selectedDateOfBirth:) forControlEvents:UIControlEventValueChanged];
    LGActionSheet *actionSheet=[[LGActionSheet alloc] initWithTitle:@""
                                                               view:datePicker
                                                       buttonTitles:@[@"Done"]
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                      actionHandler:nil
                                                      cancelHandler:nil
                                                 destructiveHandler:nil];
    actionSheet.delegate=self;
    [actionSheet showAnimated:YES completionHandler:nil];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    //[self rel];
}
@end
