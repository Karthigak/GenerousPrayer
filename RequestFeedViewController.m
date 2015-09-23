//
//  RequestFeedViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 18/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//
#import "Constants.h"
#import "RequestFeedViewController.h"
#import "HMSegmentedControl.h"
#import "RequestFeedCell.h"
#import "CommonMethodClass.h"
#import "RequestFeedMineCell.h"
#import "AddMyRequestTabViewController.h"
#import "SettingViewController.h"
#import "RequestTabViewController.h"


#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"
#import "OthersViewRequestViewController.h"
#import "OthersProfileViewController.h"
@interface RequestFeedViewController ()
{
    HMSegmentedControl *headerBar ;
    HMSegmentedControl *tabBar ;
    int selectedIndex;
    int headerSelectedIndex;

    CGFloat viewWidth;
    CGFloat viewHeight;
    NSString *someString;
    NSString *noData;
    CGFloat swipeWidth;
    CGFloat yOffset ;
    CGFloat buttonY ;
    CGFloat buttonX ;
    MBProgressHUD *HUD;

    NSUserDefaults *defaults;
    NSMutableArray *serverDatas;
    int previousSelectdIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)settingView:(id)sender;
- (IBAction)addMyRequest:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addBttn;
@property (weak, nonatomic) IBOutlet UILabel *topShadowLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *topBar;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;
@property(nonatomic,strong)NSArray *posArray;
@property(nonatomic,strong)NSString *orientation;

@end

@implementation RequestFeedViewController
-(void)drawView{
    if (isiPad) {
        
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }
    else
    {
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
    }
    else
    {
        [self.naviLbl setFrame:CGRectMake(self.naviLbl.bounds.origin.x, self.naviLbl.bounds.origin.y,600, self.naviLbl.bounds.size.height)];
        
    }
    CALayer *layer = self.naviLbl.layer;
//    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.naviLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, -2.0f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
    
   

    
}
-(void)topShadowLable
{
    
    if (isiPad) {
        
        [self.topShadowLbl setFrame:CGRectMake(self.topShadowLbl.bounds.origin.x, self.topShadowLbl.bounds.origin.y,1024, self.topShadowLbl.bounds.size.height)];
    }
    else
    {
        [self.topShadowLbl setFrame:CGRectMake(self.topShadowLbl.bounds.origin.x, self.topShadowLbl.bounds.origin.y,600, self.topShadowLbl.bounds.size.height)];
        
    }
    CALayer *layer = self.topShadowLbl.layer;
    //
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.topShadowLbl.bounds];
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f,0.5f);
    layer.shadowOpacity = 0.7f;
    layer.shadowPath = shadowPath.CGPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    serverDatas=[NSMutableArray array];
    defaults=[NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBarHidden=YES;
    self.tableView.backgroundColor=[UIColor clearColor];
    [self drawLable];
    [self topShadowLable];
    //_tableView.canCancelContentTouches = NO;
    yOffset = 0.0;
    buttonY=self.addBttn.frame.origin.y;
    buttonX=self.addBttn.frame.origin.x;

    UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#2A50AB"];
    UIColor *tintColor=[CommonMethodClass pxColorWithHexValue:@"#3D62B3"];
    
    
    self.topBar.backgroundColor = backColor;
    self.topBar.tintColor =tintColor;
    self.topBar.layer.borderColor=[UIColor clearColor].CGColor;
    self.topBar.layer.cornerRadius = 0.0;
    self.topBar.layer.borderWidth = .0f;
    headerSelectedIndex=(int)self.topBar.selectedSegmentIndex;
    [self.topBar setTitle:@"Public" forSegmentAtIndex:3];
    [self.topBar setTitle:@"Following" forSegmentAtIndex:2];
    [self.topBar setTitle:@"Private" forSegmentAtIndex:0];

    UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#A1CD46"];
    // UIColor *unselectedFont=[CommonMethodClass pxColorWithHexValue:@"#C7F0F9"];
    UIColor *unselectedFont=[UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[unselectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributes
                       forState:UIControlStateNormal];
    
    
    
    NSDictionary *attributess = [NSDictionary dictionaryWithObjects:@[selectedFont] forKeys:@[NSForegroundColorAttributeName]];
    [self.topBar setTitleTextAttributes:attributess
                       forState:UIControlStateSelected];
    [self.topBar addTarget:self action:@selector(HeaderAction:) forControlEvents:UIControlEventValueChanged];
//    [self.topBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Myriad Pro" size:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    someString=@"No";
//    [self.tableView registerClass:[RequestFeedCell class] forCellReuseIdentifier:@"RequestFeedCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    selectedIndex=previousSelectdIndex;
    headerSelectedIndex=(int)self.topBar.selectedSegmentIndex;
    self.topBar.selectedSegmentIndex=previousSelectdIndex;
    NSString *temp=[NSString stringWithFormat:@"%d",previousSelectdIndex+1];
    [self listInformation:temp];
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        
        self.orientation=@"portrait";
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            if(selectedIndex==0){
                swipeWidth=260;
            }
             self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
        }
        else{
            [tabBar removeFromSuperview];
            [self tab];
            swipeWidth=300;
            if (selectedIndex==0) {
                 self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:83],[NSNumber numberWithFloat:245],[NSNumber numberWithFloat:410], nil];
            }else{
                if (IS_IPHONE_5) {
                    self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:15],[NSNumber numberWithFloat:28],[NSNumber numberWithFloat:38],[NSNumber numberWithFloat:43],[NSNumber numberWithFloat:48], nil];
                }else if (IS_IPHONE_6){
                   self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:18],[NSNumber numberWithFloat:24],[NSNumber numberWithFloat:25],[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:18], nil];
                }else if (IS_IPHONE_6_PLUS){
                    self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:25],[NSNumber numberWithFloat:38],[NSNumber numberWithFloat:48],[NSNumber numberWithFloat:55],[NSNumber numberWithFloat:60], nil];
                }

            }
            
        }
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        self.orientation=@"landscape";

        if(isiPad){
            if(selectedIndex==0){
                swipeWidth=350;
            }
            [tabBar removeFromSuperview];
            [self tab];
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:117],[NSNumber numberWithFloat:353],[NSNumber numberWithFloat:587], nil];
        }
        else{
            swipeWidth=300;
             self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:83],[NSNumber numberWithFloat:245],[NSNumber numberWithFloat:410], nil];
        }

    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [serverDatas count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (selectedIndex==0) {
         return 103;
     }
    return 121;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (selectedIndex==0) {
        
        RequestFeedMineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RequestFeedMineCell class])];
        cell.delegate=self;

         [cell customArray:[NSArray arrayWithObjects:@"View",@"Pray",@"Delete", nil] iPadposition:self.posArray];
               [cell setRightUtilityButtons:[self leftButtonsOne] WithButtonWidth:swipeWidth];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.countLbl.text=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"COUNT"]objectAtIndex:indexPath.row]                            ];
        cell.reasonLbl.text=[[serverDatas valueForKey:@"SUBJECT"]objectAtIndex:indexPath.row];
//        NSString *time=[CommonMethodClass relativeDateStringForDate:[[serverDatas valueForKey:@"TIME"]objectAtIndex:indexPath.row]];
//        cell.timeLbl.text=time;
        NSString *time=[NSDate GetTimeAgofromDate:[[serverDatas valueForKey:@"TIME"]objectAtIndex:indexPath.row]];
        cell.timeLbl.text=time;
        NSString *isAudio=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"ISAUDIO"]objectAtIndex:indexPath.row]];
        NSString *isUrgent=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"ISURGENT"]objectAtIndex:indexPath.row]];
        cell.statusImage.image = nil;
        cell.statusImageOne.image = nil;
        cell.statusImageTwo.image = nil;
        if ([isAudio isEqualToString:@"1"]&&[isUrgent isEqualToString:@"1"]) {
            cell.statusImageOne.image=[UIImage imageNamed:@"importanticon.png"];
            cell.statusImageTwo.image=[UIImage imageNamed:@"audioicon.png"];
            cell.statusImage.hidden=YES;
        }else if ([isAudio isEqualToString:@"1"]){
            cell.statusImage.image=[UIImage imageNamed:@"audioicon.png"];
            cell.statusImage.hidden=NO;

        }else if ([isUrgent isEqualToString:@"1"]){
            cell.statusImage.image=[UIImage imageNamed:@"importanticon.png"];
            cell.statusImage.hidden=NO;

        }
        return cell;
    
        }
    else
    {
        RequestFeedCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RequestFeedCell class])];
//        RequestFeedCell *cell =(RequestFeedCell *)
//        [tableView dequeueReusableCellWithIdentifier:@"RequestFeedCell" forIndexPath:indexPath];
        cell.delegate=self;
            UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
            UILabel *lineLbl=[[UILabel alloc]init];
            [lineLbl setFrame:CGRectMake(0, 120, self.tableView.frame.size.width,0.3)];
            [lineLbl setBackgroundColor:sepColor];
            [cell.contentView addSubview:lineLbl];
        cell.userImage.layer.cornerRadius =  cell.userImage.frame.size.width / 2;
        cell.userImage.layer.masksToBounds = YES;
       cell.userImage.clipsToBounds = true;
        [cell.userImage setNeedsLayout];
        [cell.userImage setNeedsUpdateConstraints];
        cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.contentView.backgroundColor=[UIColor orangeColor];
        if ([someString isEqualToString:@"No"]) {
            [cell customArray:[NSArray arrayWithObjects:@"Profile",@"View",@"Pray",@"Share",@"Delete", nil] iPadposition:self.posArray];

            [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:swipeWidth];
        }
        else{
            
        }
       
        cell.countLbl.text=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"COUNT"]objectAtIndex:indexPath.row]                            ];
        cell.reasonLbl.text=[[serverDatas valueForKey:@"SUBJECT"]objectAtIndex:indexPath.row];
//        NSString *time=[CommonMethodClass relativeDateStringForDate:[[serverDatas valueForKey:@"TIME"]objectAtIndex:indexPath.row]];
//        cell.timeLbl.text=time;
        NSString *time=[NSDate GetTimeAgofromDate:[[serverDatas valueForKey:@"TIME"]objectAtIndex:indexPath.row]];
        cell.timeLbl.text=time;
        NSString *isAudio=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"ISAUDIO"]objectAtIndex:indexPath.row]];
         NSString *isUrgent=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"ISURGENT"]objectAtIndex:indexPath.row]];
        cell.statusImage.image = nil;
        cell.statusImageOne.image = nil;
        cell.statusImageTwo.image = nil;
//        cell.userImage.image = nil;

        if ([isAudio isEqualToString:@"1"]&&[isUrgent isEqualToString:@"1"]) {
            cell.statusImageOne.image=[UIImage imageNamed:@"importanticon.png"];
            cell.statusImageTwo.image=[UIImage imageNamed:@"audioicon.png"];
            cell.statusImage.hidden=YES;

        }else if ([isAudio isEqualToString:@"1"]){
            cell.statusImage.image=[UIImage imageNamed:@"audioicon.png"];
            cell.statusImage.hidden=NO;


        }else if ([isUrgent isEqualToString:@"1"]){
            cell.statusImage.image=[UIImage imageNamed:@"importanticon.png"];
            cell.statusImage.hidden=NO;

        }
        NSString *isAnnonymous=[NSString stringWithFormat:@"%@",[[serverDatas valueForKey:@"ISANONYMOUS"]objectAtIndex:indexPath.row]];
        if ([isAnnonymous isEqualToString:@"0"]) {
             cell.nameLbl.text=[[serverDatas valueForKey:@"FIRSTNAME"]objectAtIndex:indexPath.row];
        }else{
            cell.nameLbl.text=@"Anonymous";
        }
        NSString *imageUrl=[[serverDatas valueForKey:@"IMAGEURL"]objectAtIndex:indexPath.row];
        if ([CommonMethodClass isEmpty:imageUrl]) {
           cell.userImage.image = [UIImage imageNamed:@"userprofilepic.png"];                     }else{
        NSURL *URL2 = [NSURL URLWithString: [[serverDatas valueForKey:@"IMAGEURL"]objectAtIndex:indexPath.row]];
        NSURLRequest* request2 = [NSURLRequest requestWithURL:URL2];
        
        
        [NSURLConnection sendAsynchronousRequest:request2
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data2,
                                                   NSError * error) {
                                   if (!error){
                                       if ([isAnnonymous isEqualToString:@"0"]) {
                                           cell.userImage.image = [UIImage imageWithData:data2];
                                       }else{
                                           cell.userImage.image = [UIImage imageNamed:@"anonymous.png"];                     }
                                   }
                                   
                               }];

    }
    
    
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentView.backgroundColor=[UIColor clearColor];
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;


    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OthersViewRequestViewController *OVRC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersViewRequestViewController"];
    OVRC.hidePreviousNextButton=@"yes";
    OVRC.index=(int)indexPath.row;
    OVRC.prayerId=[[serverDatas valueForKey:@"PRAYERID"]objectAtIndex:indexPath.row];
    OVRC.userId=[[serverDatas valueForKey:@"USERID"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:OVRC animated:YES];
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    {
        NSLog(@"Lanscapse");
        self.orientation=@"landscape";
        if (isiPad) {
            if (selectedIndex==0) {
                swipeWidth=350;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:117],[NSNumber numberWithFloat:353],[NSNumber numberWithFloat:587], nil];
            }
            else{
                swipeWidth=205;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:235],[NSNumber numberWithFloat:387],[NSNumber numberWithFloat:533],[NSNumber numberWithFloat:680], nil];
            }
        }
        else{
            swipeWidth=300;
           
        }
        
       
        
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    {
   
        self.orientation=@"portrait";

        if (isiPad) {
            if(selectedIndex==0){
                swipeWidth=260;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
            }
            else{
                swipeWidth=155;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:60],[NSNumber numberWithFloat:160],[NSNumber numberWithFloat:265],[NSNumber numberWithFloat:360],[NSNumber numberWithFloat:455], nil];
            }
        }
        else{
            swipeWidth=300;
        }


    }
    [self.tableView reloadData];
    
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
    tabBar.tag=1;
    tabBar.selectedSegmentIndex=1;

    [tabBar addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
   
    UIColor *dividerColor=[CommonMethodClass pxColorWithHexValue:@"#CCF3FC"];
    tabBar.verticalDividerColor =dividerColor;

    
    if (isiPad) {
        tabBar.verticalDividerWidth = 1.0f;

    }
    else
    {
        tabBar.verticalDividerWidth = 0.5f;

    }
    [self.view addSubview:tabBar];

}
-(void)HeaderAction:(id)sender
{
    [serverDatas removeAllObjects];
    UISegmentedControl *seg=(UISegmentedControl *)sender;
    selectedIndex=(int)seg.selectedSegmentIndex;
    headerSelectedIndex=selectedIndex;
    if ([self.orientation isEqualToString:@"portrait"]) {
        if (isiPad) {
            if(selectedIndex==0){
                swipeWidth=260;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
            }
            else{
                swipeWidth=155;
                 self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:60],[NSNumber numberWithFloat:160],[NSNumber numberWithFloat:265],[NSNumber numberWithFloat:360],[NSNumber numberWithFloat:455], nil];
            }
        }
        else{
            swipeWidth=300;
            if (selectedIndex==1 || selectedIndex==2 || selectedIndex==3) {
//                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:60],[NSNumber numberWithFloat:170],[NSNumber numberWithFloat:275],[NSNumber numberWithFloat:377],[NSNumber numberWithFloat:475], nil];
                if (IS_IPHONE_5) {
                    self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:15],[NSNumber numberWithFloat:28],[NSNumber numberWithFloat:38],[NSNumber numberWithFloat:43],[NSNumber numberWithFloat:48], nil];
                }else if (IS_IPHONE_6){
                    self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:18],[NSNumber numberWithFloat:24],[NSNumber numberWithFloat:25],[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:18], nil];
                }else if (IS_IPHONE_6_PLUS){
                     self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:25],[NSNumber numberWithFloat:38],[NSNumber numberWithFloat:48],[NSNumber numberWithFloat:55],[NSNumber numberWithFloat:60], nil];
                }

            }
            else{
                 self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:83],[NSNumber numberWithFloat:245],[NSNumber numberWithFloat:410], nil];
                
            }
        }

    }else{
        if (isiPad) {
            if (selectedIndex==0) {
                swipeWidth=350;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:117],[NSNumber numberWithFloat:353],[NSNumber numberWithFloat:587], nil];
            }
            else{
                swipeWidth=205;
                self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:84],[NSNumber numberWithFloat:235],[NSNumber numberWithFloat:387],[NSNumber numberWithFloat:533],[NSNumber numberWithFloat:680], nil];
            }
        }
        else{
            swipeWidth=300;
        }
        

    }
    if (selectedIndex==2 || selectedIndex==3) {
        self.addBttn.hidden=YES;
        
    }
    else{
        self.addBttn.hidden=NO;

    }
    previousSelectdIndex=selectedIndex;
    int typeToSeverDatas=selectedIndex+1;
    [self listInformation:[NSString stringWithFormat:@"%d",typeToSeverDatas]];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.tag==0) {
        NSLog(@"header tapped");
        
        selectedIndex=(int)segmentedControl.selectedSegmentIndex;
       
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"tap tapped");
        
        if (segmentedControl.selectedSegmentIndex==0) {
            ActivityViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
            [self.navigationController pushViewController:AVC animated:YES];
            
        }
       else if (segmentedControl.selectedSegmentIndex==1) {
           RequestTabViewController *AVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestTabViewController"];
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
-(void)swipeActions:(NSIndexPath *)indexpath type:(NSString *)type{
    NSString *pray=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@&user_id=%@&prayer_id=%@&type=%@",[defaults valueForKey:@"TOKEN"],[[serverDatas valueForKey:@"USERID"]objectAtIndex:indexpath.row],[[serverDatas valueForKey:@"PRAYERID"]objectAtIndex:indexpath.row],type];
    [self HUDAction];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:pray];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            [CommonMethodClass showAlert:[responseObject valueForKey:@"message"] view:self];
            NSString *temp=[NSString stringWithFormat:@"%d",previousSelectdIndex+1];
            [self listInformation:temp];
        }else if ([error_code isEqualToString:@"400"]) {
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
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
// otherwise handle the error generically
            //[self handleError:error];
        }
        
    }];
    [op start];

}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
   
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    if ([cell isKindOfClass:[RequestFeedCell class]]) {
        NSLog(@"feed cell");
        switch (index) {
            case 0:{
                OthersProfileViewController *OVCC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersProfileViewController"];
                NSLog(@"%@",[[serverDatas valueForKey:@"USERID"]objectAtIndex:cellIndexPath.row]);
                OVCC.userProfileId=[[serverDatas valueForKey:@"USERID"]objectAtIndex:cellIndexPath.row];
                [self.navigationController pushViewController:OVCC animated:YES];
            }
                break;
            case 1:{
                OthersViewRequestViewController *OVRC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersViewRequestViewController"];
                OVRC.hidePreviousNextButton=@"yes";
                OVRC.index=(int)cellIndexPath.row;
                OVRC.prayerId=[[serverDatas valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row];
                OVRC.userId=[[serverDatas valueForKey:@"USERID"]objectAtIndex:cellIndexPath.row];

                [self.navigationController pushViewController:OVRC animated:YES];
            }
                break;
            case 2:{
                [self swipeActions:cellIndexPath type:@"0"];
            }
                break;
            case 3:{
                [self swipeActions:cellIndexPath type:@"1"];

            }
                break;
            case 4:{
                [self swipeActions:cellIndexPath type:@"2"];
                [serverDatas removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
            default:
                break;
        }

    }else{
        NSLog(@"mine cell");
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        switch (index) {
            case 0:
            {
                OthersViewRequestViewController *OVRC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersViewRequestViewController"];
                OVRC.hidePreviousNextButton=@"yes";
                OVRC.prayerId=[[serverDatas valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row];
                OVRC.userId=[[serverDatas valueForKey:@"USERID"]objectAtIndex:cellIndexPath.row];
                OVRC.index=(int)cellIndexPath.row;
                [self.navigationController pushViewController:OVRC animated:YES];
            }
                break;
            case 1:
                [self swipeActions:cellIndexPath type:@"0"];
                break;
            case 2:{
                [self swipeActions:cellIndexPath type:@"2"];
                [serverDatas removeObjectAtIndex:cellIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
            default:
                break;
        }
 
    }
}
//-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 160;
//}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                                icon:[UIImage imageNamed:@"profileicon.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"viewicon.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"pray.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"shareicon.png"]];
    

    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"delete.png"]];
    

    

    return leftUtilityButtons;
}
- (NSArray *)leftButtonsOne
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"viewicon.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"pray.png"]];
    
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"delete.png"]];
    
    
    
    
    return leftUtilityButtons;
}



- (IBAction)settingView:(id)sender {
    
    SettingViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:SVC animated:YES];
}

- (IBAction)addMyRequest:(id)sender {
    if (headerSelectedIndex==0) {
        
        AddMyRequestTabViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddMyRequestTabViewController"];
        [self.navigationController pushViewController:SVC animated:YES];
           }
    else
    {
        
        RequestTabViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestTabViewController"];
        [self.navigationController pushViewController:SVC animated:YES];

    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.topBar.userInteractionEnabled=YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.topBar.userInteractionEnabled=NO;

}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%@", scrollView.contentOffset.y > targetContentOffset->y ? @"top" : @"bottom");
    NSLog(@"%@", velocity.y > 0 ? @"bottom" : @"top");
    [self scrollDown:velocity.y > 0 ? @"bottom" : @"top"];
}
-(void)scrollDown:(NSString *)str{
    
    if ([str isEqualToString:@"bottom"]) {
        [UIView beginAnimations:@"down" context:nil];
        [UIView setAnimationDuration:0.5];
//        [self.addBttn setFrame:CGRectMake(buttonX, self.addBttn.frame.origin.y+300, self.addBttn.frame.size.width, self.addBttn.frame.size.height)];
//        [self.addBttn setNeedsDisplay];
//        [self.addBttn setNeedsLayout];
        [self.addBttn setAlpha:0];

        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"up" context:nil];
        [UIView setAnimationDuration:0.5];
        [self.addBttn setAlpha:1];
//        [self.addBttn setFrame:CGRectMake(310,buttonY+50, self.addBttn.frame.size.width, self.addBttn.frame.size.height)];
//        [self.addBttn setNeedsDisplay];
//        [self.addBttn setNeedsLayout];
        [UIView commitAnimations];
        
    }
    
}
-(void)listInformation:(NSString *)type{
    [self HUDAction];
    [serverDatas removeAllObjects];
    NSString *ser=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/prayers/listRequest?access_token=%@&type=%@",[defaults valueForKey:@"TOKEN"],type];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:ser];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
         NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([errorState isEqualToString:@"400"]) {
            noData=[responseObject valueForKey:@"errors"];
            [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
            [self.tableView reloadData];
        }else if ([status isEqualToString:@"200"]){
            NSMutableDictionary *dic;
            NSDictionary *list=[responseObject valueForKey:@"message"];
            NSLog(@"%@",[list allKeys]);
            NSArray *arr=[list allKeys];
            //parsing based on pray types like friends,mine,public
            NSString *typesOfPray=[arr objectAtIndex:0];
            for (NSDictionary *temp in [list valueForKey:typesOfPray]) {
                dic=[NSMutableDictionary dictionary];
                if ([[temp valueForKey:@"from_user"] isKindOfClass:[NSDictionary class]] && [[temp valueForKey:@"prayer"] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[[temp objectForKey:@"from_user"]valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                    [dic setObject:[[temp objectForKey:@"from_user"]valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                    [dic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"audio_url"] forKey:@"AUDIOURL"];
                    [dic setObject:[[temp  objectForKey:@"prayer"]valueForKey:@"description"] forKey:@"DESCRIPTION"];
                    [dic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"overall_prayed_count"] forKey:@"COUNT"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"is_audio"] forKey:@"ISAUDIO"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"is_urgent"] forKey:@"ISURGENT"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"created_at"] forKey:@"TIME"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"subject"] forKey:@"SUBJECT"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"user_id"] forKey:@"USERID"];
                    [dic setObject:[[temp objectForKey:@"prayer"] valueForKey:@"id"] forKey:@"PRAYERID"];
                    if ([typesOfPray isEqualToString:@"my_prayers"] || [typesOfPray isEqualToString:@"following_prayers"]) {
                        
                    }else{
                        [dic setObject:[temp valueForKey:@"is_anonymous"] forKey:@"ISANONYMOUS"];
                    }
                    

                }
                else{
                    [dic setObject:[temp valueForKey:@"audio_url"] forKey:@"AUDIOURL"];
                    [dic setObject:[temp valueForKey:@"description"] forKey:@"DESCRIPTION"];
                    [dic setObject:[temp valueForKey:@"overall_prayed_count"] forKey:@"COUNT"];
                    [dic setObject:[temp valueForKey:@"is_audio"] forKey:@"ISAUDIO"];
                    [dic setObject:[temp valueForKey:@"is_urgent"] forKey:@"ISURGENT"];
                    [dic setObject:[temp valueForKey:@"created_at"] forKey:@"TIME"];
                    [dic setObject:[temp valueForKey:@"subject"] forKey:@"SUBJECT"];
                    [dic setObject:[temp valueForKey:@"user_id"] forKey:@"USERID"];
                    [dic setObject:[temp valueForKey:@"id"] forKey:@"PRAYERID"];
                    if ([typesOfPray isEqualToString:@"my_prayers"]||[typesOfPray isEqualToString:@"following_prayers"]) {
                        
                    }else{
                        [dic setObject:[temp valueForKey:@"is_anonymous"] forKey:@"ISANONYMOUS"];
                    }
                    
                    if ([[temp valueForKey:@"user"] isKindOfClass:[NSDictionary class]]) {
                        [dic setObject:[[temp objectForKey:@"user"]valueForKey:@"first_name"] forKey:@"FIRSTNAME"];
                        [dic setObject:[[temp objectForKey:@"user"]valueForKey:@"image_url"] forKey:@"IMAGEURL"];
                    }

                }
                [serverDatas addObject:dic];
            }
            NSLog(@"%lu",(unsigned long)serverDatas.count);
            [self.tableView reloadData];
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
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
            // otherwise handle the error generically
            //[self handleError:error];
        }
        
    }];
    [op start];
}
-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSArray *visibleCells = [self.tableView visibleCells];
//    [visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        MyTableViewCell *cell = (MyTableViewCell *)obj;
//        NSString *url = ...;
//        [cell showImageURL:url];
//    }];
//}
@end
