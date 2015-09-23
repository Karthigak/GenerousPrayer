//
//  NotificationTabViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 23/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "NotificationTabViewController.h"
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "SettingViewController.h"
#import "CommonMethodClass.h"
#import "RequestFeedViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "OthersProfileViewController.h"
@interface NotificationTabViewController ()
{
    CGFloat swipeWidth;
    MBProgressHUD *HUD;
    NSMutableArray *activityList;
    NSUserDefaults *defaults;

}
- (IBAction)settingsView:(id)sender;
@property(nonatomic,strong)NSArray *posArray;

@end

@implementation NotificationTabViewController
-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}
-(void)drawBorder
{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    activityList=[NSMutableArray array];
    self.tableView.backgroundColor=[UIColor clearColor];
    [self drawBorder];
    [self drawLable];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self listActivity];
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];

            swipeWidth=260;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
        }
        else{
            [tabBar removeFromSuperview];
            [self tab];
            swipeWidth=300;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:353],[NSNumber numberWithFloat:117],[NSNumber numberWithFloat:587], nil];
        }
        
        
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            [tabBar removeFromSuperview];
            [self tab];
            CGFloat width = CGRectGetWidth(self.view.bounds);
            viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
            swipeWidth=342;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:113],[NSNumber numberWithFloat:340],[NSNumber numberWithFloat:570], nil];
        }
        else{
            swipeWidth=300;
            
        }
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activityList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityCell class])];
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.userImage.layer.cornerRadius =  cell.userImage.frame.size.width / 2;
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.clipsToBounds = true;
    [cell.userImage setNeedsLayout];
    [cell.userImage setNeedsUpdateConstraints];
    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
    NSString *checkString=[NSString stringWithFormat:@"%@",[[activityList valueForKey:@"TYPEID"]objectAtIndex:indexPath.row]];
    if([checkString isEqualToString:@"3"]){
        cell.statusLbl.text=@"Friend requests";
    }else if ([checkString isEqualToString:@"4"]){
        cell.statusLbl.text=@"Someone Follows you";
    }else if ([checkString isEqualToString:@"5"]){
        cell.statusLbl.text=@"Someone Shares your request ";
    }else if ([checkString isEqualToString:@"6"]){
        cell.statusLbl.text=@"A Friend's new prayer request";
    }else if ([checkString isEqualToString:@"7"]){
        cell.statusLbl.text=@"A Person you follow Prayer request";
    }else if ([checkString isEqualToString:@"8"]){
        cell.statusLbl.text=@"When someone prays for you";
    }else if ([checkString isEqualToString:@"9"]){
        cell.statusLbl.text=@"A Prayer request of yours is expiring";
    }else if ([checkString isEqualToString:@"10"]){
        cell.statusLbl.text=@"Someone Hearts your action";
    }else if ([checkString isEqualToString:@"11"]){
        cell.statusLbl.text=@"The person you invited joined";
    }
    cell.timeLbl.text=[CommonMethodClass relativeDateStringForDate:[[activityList valueForKey:@"CREATEDDATE"]objectAtIndex:indexPath.row]];
    NSString *checkImage=[[activityList valueForKey:@"FROMUSERIMAGE"]objectAtIndex:indexPath.row];
    if ([checkImage isKindOfClass:[NSNull class]]) {

    }else{
        NSURL *URL2 = [NSURL URLWithString: [[activityList valueForKey:@"FROMUSERIMAGE"]objectAtIndex:indexPath.row]];
        NSURLRequest* request2 = [NSURLRequest requestWithURL:URL2];
        [NSURLConnection sendAsynchronousRequest:request2
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data2,
                                                   NSError * error) {
                                   if (!error){
                                       cell.userImage.image = [UIImage imageWithData:data2];
                                   }
                               }];
  
    }
//     [cell customArray:[NSArray arrayWithObjects:@"Friend",@"Follow",@"Profile", nil] iPadposition:self.posArray];
//    [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:swipeWidth];

//    if (indexPath.row==0) {
//        cell.statusLbl.text=@"Jhon henry prayed for you";
//        cell.timeLbl.text=@"5m ago";
//        
//    }
//    else if (indexPath.row==1)
//    {
//        cell.statusLbl.text=@"Danial followed you";
//        cell.timeLbl.text=@"15m ago";
//        
//    }
//    else if (indexPath.row==2)
//    {
//        cell.statusLbl.text=@"Alex sent a friend request";
//        cell.timeLbl.text=@"1h ago";
//        
//        
//    } else if (indexPath.row==3)
//    {
//        cell.statusLbl.text=@"Oliva joined generoues prayer";
//        cell.timeLbl.text=@"2m ago";
//        
//    }
    
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0, 108, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
        
    return cell;
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    [tabBar setFrame:CGRectMake(0, viewHeight-50, width, 50)];
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    {
        NSLog(@"Lanscapse");
        swipeWidth=342;
        self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:113],[NSNumber numberWithFloat:340],[NSNumber numberWithFloat:570], nil];
        
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    {
        swipeWidth=260;
        self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
        
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
    tabBar.selectedSegmentIndex=4;
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
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.tag==0) {
        NSLog(@"header tapped");
        
        
    }
    else
    {
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

-(void)profile:(NSIndexPath *)indexPath{
    OthersProfileViewController *OVCC=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersProfileViewController"];
    OVCC.userProfileId=[[activityList valueForKey:@"TOUSERID"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:OVCC animated:YES];
}
-(void)swipeDelete_Confirm_block:(NSString *)type atIndex:(NSIndexPath *)indexPath{
    [self HUDAction];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/userAction?access_token=%@&&user_id=%@&&type=%@",[defaults valueForKey:@"TOKEN"],[[activityList valueForKey:@"TOUSERID"]objectAtIndex:indexPath.row],type];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            [CommonMethodClass showAlert:[responseObject valueForKey:@"message"] view:self];
            [self.tableView reloadData];
        }else if ([error_code isEqualToString:@"400"]) {
            [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
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
-(void)follow:(NSIndexPath *)indexPath{
    [self HUDAction];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/followFriend?access_token=%@&&friend_id=%@",[defaults valueForKey:@"TOKEN"],[[activityList valueForKey:@"TOUSERID"]objectAtIndex:indexPath.row]];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            [CommonMethodClass showAlert:[responseObject valueForKey:@"message"] view:self];
            [self.tableView reloadData];
        }else if ([error_code isEqualToString:@"400"]) {
            [CommonMethodClass showAlert:[responseObject valueForKey:@"errors"] view:self];
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ActivityCell *selectedCell=(ActivityCell *)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForCell:cell]];
    NSLog(@"activity-------->%@",selectedCell.statusLbl.text);
    NSString *checkSwipeActionsAttachableType=selectedCell.statusLbl.text;
    if ([checkSwipeActionsAttachableType isEqualToString:@"PrayerActivity"]) {
        switch (index){
            case 0:
                [self profile:cellIndexPath];
                break;
            case 1:
                break;
            case 2:
                [self swipeDelete_Confirm_block:@"1" atIndex:cellIndexPath];
                break;
            default:
                break;
        }
        
    }else if ([checkSwipeActionsAttachableType isEqualToString:@"FriendRequest"]){
        switch (index){
            case 0:
                [self swipeDelete_Confirm_block:@"0" atIndex:cellIndexPath];
                break;
            case 1:
                break;
            case 2:
                [self swipeDelete_Confirm_block:@"2" atIndex:cellIndexPath];
                break;
            default:
                break;
        }
    }else if ([checkSwipeActionsAttachableType isEqualToString:@"Follow"]){
        switch (index){
            case 0:
                [self profile:cellIndexPath];
                break;
            case 1:
                [self follow:cellIndexPath];
                break;
            case 2:
                [self swipeDelete_Confirm_block:@"2" atIndex:cellIndexPath];
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
                                                icon:[UIImage imageNamed:@"addfriend.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"follow.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"profileicon.png"]];
    
    
    
    
    
    return leftUtilityButtons;
}
- (NSArray *)leftButtonsOne
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                                icon:[UIImage imageNamed:@"profileicon.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"follow.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"block.png"]];
    
    
    
    
    return leftUtilityButtons;
}
- (NSArray *)leftButtonsOneTwo
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                                icon:[UIImage imageNamed:@"friendactivewhite.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"ignore.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"block.png"]];
    
    
    
    
    return leftUtilityButtons;
}

- (IBAction)settingsView:(id)sender {
    
    SettingViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    
    [self.navigationController pushViewController:SVC animated:YES];
}
-(void)listActivity{
    [self HUDAction];
    [activityList removeAllObjects];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/notifications?access_token=%@",[defaults valueForKey:@"TOKEN"]];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            NSDictionary *dictonary=[responseObject valueForKey:@"message"];
            NSMutableDictionary *dict;
            for (NSArray *dic in  [dictonary valueForKey:@"Notification"]) {
                dict=[NSMutableDictionary dictionary];
                [dict setObject:[dic valueForKey:@"created_at"] forKey:@"CREATEDDATE"];
                if ([[dic valueForKey:@"from_user"] isKindOfClass:[NSDictionary class]]) {
                   [dict setObject:[[dic valueForKey:@"from_user"]valueForKey:@"first_name"]forKey:@"FROMUSERNAME"];
                     [dict setObject:[[dic valueForKey:@"from_user"]valueForKey:@"image_url"]forKey:@"FFROMUSERIMAGE"];
                }
                [dict setObject:[dic valueForKey:@"from_user_id"] forKey:@"FROMUSERID"];
                [dict setObject:[dic valueForKey:@"id"] forKey:@"PRAYERID"];
                [dict setObject:[dic valueForKey:@"is_read"] forKey:@"ISREAD"];
                if ([[dic valueForKey:@"notificable"] isKindOfClass:[NSDictionary class]]) {
                    [dict setObject:[[dic valueForKey:@"notificable"]valueForKey:@"id"]forKey:@"NOTIFICABLEID"];
                }
                [dict setObject:[dic valueForKey:@"notification_type_id"] forKey:@"TYPEID"];
                if ([[dic valueForKey:@"to_user"] isKindOfClass:[NSDictionary class]]) {
                    [dict setObject:[[dic valueForKey:@"to_user"]valueForKey:@"first_name"]forKey:@"TOUSERNAME"];
                }
                [dict setObject:[dic valueForKey:@"to_user_id"] forKey:@"TOUSERID"];


                [activityList addObject:dict];
            }
            [self.tableView reloadData];
        }else if([error_code isEqualToString:@"400"]){
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

@end
