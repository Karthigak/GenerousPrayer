//
//  PrayerTimerViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 18/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "PrayerTimerViewController.h"
#import "SettingViewController.h"
#import "CommonMethodClass.h"
#import "Constants.h"
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "RequestFeedViewController.h"
#import "PrayCompletedViewController.h"
#import "NIDropDown.h"
#import "TimerScreen.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CustomAFNetworking.h"
#import "PrayCompletedViewController.h"
#import "RMActionController.h"
#import "RMDateSelectionViewController.h"
@interface PrayerTimerViewController ()<NIDropDownDelegate,LGActionSheetDelegate>
{
    NSString *selectedString;
    NIDropDown *dropDown;
    BOOL isCategoryClicked;
    BOOL issecondsClicked;
    MBProgressHUD *HUD;
    NSMutableArray *categoryList;
    NSString *categoryId;
    BOOL isAnonmous;
    BOOL isPublic;
    BOOL isFriends;
    BOOL isMine;
    BOOL isUrgent;
    BOOL isAll;
    NSString *leastString;
    NSString *requestAvailale;
    NSMutableArray *typesArray;
    NSMutableArray *datasArray;
    NSString *isAnonmousFlag;
    NSString *isPublicFlag;
    NSString *isFriendsFlag;
    NSString *isMineFlag;
    NSString *isUrgentFlag;
    NSString *isAllFlag;
    NSString *totalTimer;
    BOOL isButtonTitleChange;
    NSUserDefaults *defaults;
    RMDateSelectionViewController *dateSelectionController;
    NSArray *secondsArray;


}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)settingsView:(id)sender;
- (IBAction)prayMore:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;
@property (strong, nonatomic) IBOutlet UIButton *buttonSeconds;

@end

@implementation PrayerTimerViewController
-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedString=@"Categories";
    typesArray=[NSMutableArray array];
    datasArray=[NSMutableArray array];
    defaults=[NSUserDefaults standardUserDefaults];
    self.tableView.backgroundColor=[UIColor clearColor];
    [self drawLable];
    [self drawBorder];
    categoryList=[NSMutableArray array];
    self.categoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.categoryButton setTitle:[NSString stringWithFormat:@"  Category"] forState:UIControlStateNormal];
    secondsArray = [NSArray arrayWithObjects:@"30 Secs", @"45 Secs", @"1 min",@"1.15 mins",@"1.30 mins",@"1.45 mins",@"2 mins",@"3 mins", @"4 mins",@"5 mins",nil];
    // Do any additional setup after loading the view.
}
-(void)drawBorder
{
    if (isiPad) {
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }else{
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,600, self.naviView.bounds.size.height)];
    }
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviView.bounds];
    self.naviView.layer.masksToBounds = NO;
    self.naviView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.naviView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.naviView.layer.shadowOpacity = 0.3f;
    self.naviView.layer.shadowPath = shadowPath.CGPath;
    
}
-(void)drawLable
{
    if (isiPad) {
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,1024, self.naviLbl.bounds.size.height)];
    }else{
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,600, self.naviLbl.bounds.size.height)];
    }
    CALayer *layer = self.naviLbl.layer;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
    
}
-(void)viewWillAppear:(BOOL)animated{
    dropDown = [[NIDropDown alloc]init];
    dropDown.delegate = self;
    [self listCategory];
    leastString=@"1";
    requestAvailale=@"1";
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
        }
        else{
            [tabBar removeFromSuperview];
            [self tab];
        }
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
       
        }
        else{
            
        }
        
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setSecs:(id)sender {
    NSString*temp= [self.categoryButton currentTitle];
    if ([temp isEqualToString:@"  Category"]) {
        [CommonMethodClass showAlert:@"Please choose your Category" view:self];
    }else{
        if(issecondsClicked==NO) {
            CGFloat f = 150;
            [dropDown showDropDown:sender :&f :secondsArray :nil :@"up"];
            issecondsClicked=YES;
            isCategoryClicked=NO;
        }
        else {
            [dropDown hideDropDown:sender];
            issecondsClicked=NO;
            
        }
  
    }
    
}
- (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index{
   // self.expireLbl.text=expireDate;
}
-(void)selectedDateOfBirth:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    NSString *formatedDate = [dateFormatter stringFromDate:datePicker.date];
    totalTimer=formatedDate;
    [self.butotnTotalTimer setTitle:[NSString stringWithFormat:@"%@",totalTimer] forState:UIControlStateNormal];

}
-(void)datePicker
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.frame = CGRectMake(0.f, 0.f, datePicker.frame.size.width, 100.f);
    datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
    [datePicker setLocale:[NSLocale currentLocale]];
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

- (IBAction)setTime:(id)sender {
    self.categoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   // [self datePicker];
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    RMAction *selectAction = [RMAction actionWithTitle:@"Select Time" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@",dateSelectionController.datePicker.date);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm:ss";
        NSString *formatedDate = [dateFormatter stringFromDate:dateSelectionController.datePicker.date];
        totalTimer=formatedDate;
        [self.butotnTotalTimer setTitle:[NSString stringWithFormat:@"%@",totalTimer] forState:UIControlStateNormal];
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Select Time";
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
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
- (IBAction)selectClicked:(id)sender {
    
    NSMutableArray *temp=[NSMutableArray array];
    for (int i=0; i<[categoryList count]; i++) {
        [temp addObject:[[categoryList objectAtIndex:i]valueForKey:@"NAME"]];
    }
    isButtonTitleChange=YES;
    if(isCategoryClicked==NO) {
        CGFloat f = 150;
        [dropDown showDropDown:sender :&f :temp :nil :@"down"];
        isCategoryClicked=YES;
    }else{
        [dropDown hideDropDown:sender];
        isCategoryClicked=NO;
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    //[self rel];
}
-(void)selectedString:(NSString *)text{
   issecondsClicked=NO;
    selectedString=text;
    if (isButtonTitleChange) {
        [self.categoryButton setTitle:[NSString stringWithFormat:@"  %@",selectedString] forState:UIControlStateNormal];
        isButtonTitleChange=NO;
    }else{
    }
}
-(void)selectedIndex:(int)index{
        if(isCategoryClicked == YES){
            categoryId=[NSString stringWithFormat:@"%@",[[categoryList objectAtIndex:index]valueForKey:@"ID"]];
            isCategoryClicked=NO;
            
        }
}

-(void)rel{
    //    [dropDown release];
    //dropDown = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
    
}
-(void)tab
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    viewWidth = CGRectGetWidth(self.view.frame);
    viewHeight = CGRectGetHeight(self.view.frame);
    NSMutableArray *unselect=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"activity.png"], [UIImage imageNamed:@"request.png"], [UIImage imageNamed:@"praymenu.png"], [UIImage imageNamed:@"mine.png"],[UIImage imageNamed:@"notification.png"], nil];
    NSMutableArray *select=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"activityactive.png"], [UIImage imageNamed:@"requestactive.png"], [UIImage imageNamed:@"praymenuactive.png"],[UIImage imageNamed:@"mineactive.png"],[UIImage imageNamed:@"notificationactive.png"], nil];
    tabBar = [[HMSegmentedControl alloc] initWithSectionImages:unselect sectionSelectedImages:select];
    
    [tabBar setFrame:CGRectMake(0, viewHeight-50, viewWidth, 50)];
    tabBar.selectionIndicatorHeight = 4.0f;
    tabBar.backgroundColor = [UIColor clearColor];
    tabBar.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    tabBar.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    tabBar.selectionStyle = HMSegmentedControlSelectionStyleBox;
    tabBar.shouldAnimateUserSelection = NO;
    tabBar.verticalDividerEnabled = YES;
    tabBar.selectedSegmentIndex=2;
    [tabBar addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    tabBar.tag=1;
    
    UIColor *dividerColor=[CommonMethodClass pxColorWithHexValue:@"#CCF3FC"];
    tabBar.verticalDividerColor =dividerColor;
    if (isiPad) {
        tabBar.verticalDividerWidth = 1.0f;
    }else{
        tabBar.verticalDividerWidth = 0.5f;
    }
    [self.view addSubview:tabBar];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.tag==0) {
        NSLog(@"header tapped");
    }else{
        NSLog(@"tap tapped");
        
        if (segmentedControl.selectedSegmentIndex==0) {
            ActivityViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==1) {
            RequestFeedViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestFeedViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==2) {
            PrayerTimerViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayerTimerViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==3) {
            MyProfileViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        else if (segmentedControl.selectedSegmentIndex==4) {
            NotificationTabViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationTabViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
        
    }
    
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingsView:(id)sender {
    
    SettingViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)prayMore:(id)sender {
    NSLog(@"%@",self.butotnTotalTimer.titleLabel.text);
    if ([self.categoryButton.titleLabel.text isEqualToString:@"  Category"]) {
        [CommonMethodClass showAlert:@"Select Category List" view:self];
    }else if ([CommonMethodClass isEmpty:self.butotnTotalTimer.titleLabel.text ]){
        [CommonMethodClass showAlert:@"Select your prayer time" view:self];
    }else if ([CommonMethodClass isEmpty:self.buttonSeconds.titleLabel.text ]){
        [CommonMethodClass showAlert:@"Select your prayer time between duration" view:self];
    }else if ([self.butotnTotalTimer.titleLabel.text isEqualToString:@"00:00:00"]){
      [CommonMethodClass showAlert:@"Atleast select five minutes" view:self];
    }else{
    [typesArray removeAllObjects];
    if ([isAnonmousFlag isEqualToString:@"1"]) {
        [typesArray addObject:@"1"];
    }if ([isPublicFlag isEqualToString:@"1"]){
        [typesArray addObject:@"2"];
    }if ([isMineFlag isEqualToString:@"1"]){
        [typesArray addObject:@"3"];
    }if ([isFriendsFlag isEqualToString:@"1"]){
        [typesArray addObject:@"4"];
    }if ([isUrgentFlag isEqualToString:@"1"]){
        [typesArray addObject:@"5"];
    }if ([isAllFlag isEqualToString:@"1"]){
        [typesArray addObject:@"6"];
    }
    NSLog(@"%@",typesArray);
    }
    NSDictionary *sendDic;
    NSArray *array=[NSArray arrayWithArray:typesArray];
    if([array count]==0){
//        categoryId=@"";
//       sendDic=@{@"access_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],@"category_id":categoryId,@"least_first":leastString,@"filter_audio_requests":requestAvailale};
        [CommonMethodClass showAlert:@"Select filtration type" view:self];
    }else{
        NSLog(@"Category id--------->%@",categoryId);
       sendDic=@{@"access_token":[[NSUserDefaults standardUserDefaults]valueForKey:@"TOKEN"],@"category_id":categoryId,@"filter_id":array,@"least_first":leastString,@"filter_audio_requests":requestAvailale};
        [self HUDAction];
        NSMutableURLRequest*   request=[CustomAFNetworking postMethodWithUrl:@"http://192.237.241.156:9000/v1/prayerList" dictornay:sendDic];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [HUD hide:YES];
            
            NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
            if([status isEqualToString:@"200"]){
                NSDictionary *messageDic=[responseObject valueForKey:@"message"];
                NSMutableDictionary *dic;
                for(NSDictionary *tmp in [messageDic valueForKey:@"prayer_list"])
                {
                    dic=[NSMutableDictionary dictionary];
                    NSString *type=[NSString stringWithFormat:@"%@",[tmp valueForKey:@"is_prayer_activity"]];
                    if([type isEqualToString: @"1"]){
                        [dic setObject:[tmp valueForKey:@"like_count"] forKey:@"LIKECOUNT"];
                        [dic setObject:[tmp valueForKey:@"prayed_count"] forKey:@"PRAYEDCOUNT"];
                        [dic setObject:[tmp valueForKey:@"prayed_time"] forKey:@"PRAYEDTIME"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"audio_url"] forKey:@"AUDIOURL"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"overall_like_count"] forKey:@"OVERALLCOUNT"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"overall_prayed_count"] forKey:@"OVERALLPRAYEDCOUNT"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"subject"] forKey:@"SUBJECT"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"description"] forKey:@"DESCRIPTION"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"is_audio"] forKey:@"ISAUDIO"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"id"] forKey:@"ID"];
                        [dic setObject:[[tmp valueForKey:@"prayer"]valueForKey:@"user_id"] forKey:@"USERID"];
                        if([[[tmp valueForKey:@"prayer"]valueForKey:@"category"] isKindOfClass:[NSDictionary class]] && [[[tmp valueForKey:@"prayer"]valueForKey:@"user"] isKindOfClass:[NSDictionary class]]){
                            [dic setObject:[[[tmp valueForKey:@"prayer"]valueForKey:@"category"]valueForKey:@"name"] forKey:@"CATEGORYNAME"];
                            [dic setObject:[[[tmp valueForKey:@"prayer"]valueForKey:@"user"]valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                            [dic setObject:[[[tmp valueForKey:@"prayer"]valueForKey:@"user"]valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                            [datasArray addObject:dic];
                            
                        }
                        
                    }
                    else{
                        [dic setObject:[tmp valueForKey:@"audio_url"] forKey:@"AUDIOURL"];
                        [dic setObject:[tmp valueForKey:@"overall_like_count"] forKey:@"OVERALLCOUNT"];
                        [dic setObject:[tmp valueForKey:@"overall_prayed_count"] forKey:@"OVERALLPRAYEDCOUNT"];
                        [dic setObject:[tmp valueForKey:@"subject"] forKey:@"SUBJECT"];
                        [dic setObject:[tmp valueForKey:@"description"] forKey:@"DESCRIPTION"];
                        [dic setObject:[tmp valueForKey:@"is_audio"] forKey:@"ISAUDIO"];
                        [dic setObject:[tmp valueForKey:@"id"] forKey:@"ID"];
                        [dic setObject:[tmp valueForKey:@"user_id"] forKey:@"USERID"];
                        if([[tmp valueForKey:@"category"] isKindOfClass:[NSDictionary class]] && [[tmp valueForKey:@"user"] isKindOfClass:[NSDictionary class]]){
                            [dic setObject:[[tmp valueForKey:@"category"]valueForKey:@"name"] forKey:@"CATEGORYNAME"];
                            [dic setObject:[[tmp valueForKey:@"user"]valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                            [dic setObject:[[tmp valueForKey:@"user"]valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                            [datasArray addObject:dic];
                            
                        }
                    }
                }
                NSLog(@"%@",datasArray);
                if ([datasArray count]==0) {
                    [CommonMethodClass showAlert:@"Try with other filter optios" view:self];
                    
                }else{
                    TimerScreen *PCVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TimerScreen"];
                    PCVC.datas=datasArray;
                    PCVC.totalPrayTimer=totalTimer;
                    PCVC.betweenPrayer=self.buttonSeconds.titleLabel.text;
                    [self.navigationController pushViewController:PCVC animated:YES];
                }
                
            }else if([error_code isEqualToString:@"400"]){
                isCategoryClicked=NO;
                [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [HUD hide:YES];
            if ([error code] == kCFURLErrorNotConnectedToInternet)
            {
            }else if([error code]==kCFURLErrorTimedOut){
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }else if([error code]==kCFURLErrorBadServerResponse){
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }else if([error code]==kCFURLErrorCannotConnectToHost){
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }
            else
            {
                // otherwise handle the error generically
                //[self handleError:error];
            }
            
        }];
        [op start];

    }
    

    
}

- (IBAction)Allaction:(id)sender {
    

    UIButton *button=(UIButton *)sender;
    
    if (button.tag==0) {
            if(isAnonmous==NO) {
            isAnonmous=YES;
            isAnonmousFlag=@"1";
            [self.anonButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                
                if (([isUrgentFlag isEqualToString:@"1"]) && ([isFriendsFlag isEqualToString:@"1"])&&([isMineFlag isEqualToString:@"1"]) && ([isPublicFlag isEqualToString:@"1"])) {
                    isAllFlag=@"1";
                    [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
                }
                
        }
        else {
            isAnonmous=NO;
            isAnonmousFlag=@"0";
            [self.anonButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isAllFlag=@"0";
            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
        }
        
    }else if (button.tag==1){
        if(isPublic==NO) {
            isPublic=YES;
            isPublicFlag=@"1";
            [self.publicButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            if (([isUrgentFlag isEqualToString:@"1"]) && ([isFriendsFlag isEqualToString:@"1"])&&([isMineFlag isEqualToString:@"1"]) && ([isAnonmousFlag isEqualToString:@"1"])) {
                isAllFlag=@"1";
                [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            }
        }
        else {
            isPublic=NO;
            isPublicFlag=@"0";
            [self.publicButton setImage:[UIImage imageNamed:@"checkbox"]  forState:UIControlStateNormal];
            isAllFlag=@"0";
            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
        }
        
    }else if (button.tag==2){
        if(isMine==NO) {
            isMine=YES;
            isMineFlag=@"1";
            [self.mineButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            
            if (([isUrgentFlag isEqualToString:@"1"]) && ([isFriendsFlag isEqualToString:@"1"])&&([isPublicFlag isEqualToString:@"1"]) && ([isAnonmousFlag isEqualToString:@"1"])) {
                isAllFlag=@"1";
                [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            }

        }
        else {
            isMine=NO;
            isMineFlag=@"0";
            [self.mineButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isAllFlag=@"0";
            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
        }
        
    }else if (button.tag==3){
        if(isFriends==NO) {
            isFriends=YES;
            isFriendsFlag=@"1";
            [self.friendsButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            if (([isUrgentFlag isEqualToString:@"1"]) && ([isMineFlag isEqualToString:@"1"])&&([isPublicFlag isEqualToString:@"1"]) && ([isAnonmousFlag isEqualToString:@"1"])) {
                isAllFlag=@"1";
                [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            }
        }
        else {
            isFriends=NO;
            isFriendsFlag=@"0";
            [self.friendsButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isAllFlag=@"0";
            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];

        }
        
    }else if (button.tag==4){
        if(isUrgent==NO) {
            isUrgent=YES;
            isUrgentFlag=@"1";
            [self.urgntButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            if (([isFriendsFlag isEqualToString:@"1"]) && ([isMineFlag isEqualToString:@"1"])&&([isPublicFlag isEqualToString:@"1"]) && ([isAnonmousFlag isEqualToString:@"1"])) {
                isAllFlag=@"1";
                [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            }
        }
        else {
            isUrgent=NO;
            isUrgentFlag=@"0";
            [self.urgntButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            isAllFlag=@"0";
            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
        }
        
    }else if (button.tag==5){
        if(isAll==NO) {
            isAll=YES;
            isAllFlag=@"1";
            isUrgentFlag=@"1";
            isFriendsFlag=@"1";
            isMineFlag=@"1";
            isPublicFlag=@"1";
            isAnonmousFlag=@"1";
            [self.allButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
             [self.urgntButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
             [self.friendsButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
              [self.mineButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            [self.publicButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
            [self.anonButton setImage:[UIImage imageNamed:@"checked"]forState:UIControlStateNormal];
        }
        else {
            isAll=NO;
            isAllFlag=@"0";
            isUrgentFlag=@"0";
            isFriendsFlag=@"0";
            isMineFlag=@"0";
            isPublicFlag=@"0";
            isAnonmousFlag=@"0";

            [self.allButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
            [self.urgntButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
            [self.friendsButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            [self.mineButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
            [self.publicButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
            [self.anonButton setImage:[UIImage imageNamed:@"checkbox"]forState:UIControlStateNormal];
        }
        
    }
}

- (IBAction)switchAction:(id)sender {
    UISwitch *swich=(UISwitch *)sender;
    if(swich.tag==0){
        if (swich.isOn) {
            leastString=@"0";
        }else{
            leastString=@"1";
          }
    }else{
        if (swich.isOn) {
            requestAvailale=@"1";

        }else{
            requestAvailale=@"0";

        }
    }
}
-(void)listCategory{
    [self HUDAction];
    NSString *string=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/categories?access_token=%@",[defaults valueForKey:@"TOKEN"]];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:string
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
        
        
        NSMutableDictionary *dict;
        for (NSArray *dic in  [responseObject valueForKey:@"message"]) {
            dict=[NSMutableDictionary dictionary];
            [dict setObject:[dic valueForKey:@"name"] forKey:@"NAME"];
            [dict setObject:[dic valueForKey:@"id"] forKey:@"ID"];
            [categoryList addObject:dict];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
        }else if([error code]==kCFURLErrorTimedOut){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }else if([error code]==kCFURLErrorBadServerResponse){
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }
        else
        {
            // otherwise handle the error generically
            //[self handleError:error];
        }
        
    }];
    [op start];
    
    
}

-(IBAction)dateAction:(id)sender{
    
   }


@end
