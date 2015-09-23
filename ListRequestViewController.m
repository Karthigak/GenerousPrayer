//
//  ListRequestViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ListRequestViewController.h"
#import "ListRequestCell.h"
#import "CommonMethodClass.h"
#import "OthersViewRequestViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"

@interface ListRequestViewController ()
{
    CGFloat swipeWidth;
    MBProgressHUD *HUD;
    NSMutableArray *requestData;
    NSUserDefaults *userInfo;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *naviView;
- (IBAction)back:(id)sender;
@property(nonatomic,strong)NSArray *posArray;

@end

@implementation ListRequestViewController
@synthesize userProfileId;
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
    userInfo = [NSUserDefaults standardUserDefaults];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    self.tableView.backgroundColor=[UIColor clearColor];
    [self drawBorder];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self listRequestAction];
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            swipeWidth=260;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
        }else{
            swipeWidth=300;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:353],[NSNumber numberWithFloat:117],[NSNumber numberWithFloat:587], nil];
        }
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            swipeWidth=342;
            self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:113],[NSNumber numberWithFloat:340],[NSNumber numberWithFloat:570], nil];
        }else{
            swipeWidth=300;
            
        }
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight){
        NSLog(@"Lanscapse");
        swipeWidth=342;
        self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:113],[NSNumber numberWithFloat:340],[NSNumber numberWithFloat:570], nil];
        
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown ){
        swipeWidth=260;
        self.posArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:75],[NSNumber numberWithFloat:218],[NSNumber numberWithFloat:361], nil];
        
    }
   // [self.tableView reloadData];
}
-(void)prayRequestAction:(NSString *)prayerID requestFlag:(NSString *)flag{
    [self HUDAction];
    
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@f&user_id=%@&prayer_id=%@&type=%@",[userInfo valueForKey:@"TOKEN"],userProfileId,prayerID,flag]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *successMessage=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"message"]];

        if ([successStatus isEqualToString:@"200"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:successMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }else if([errorState isEqualToString:@"400"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:@"No result found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
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
        }
    
    }];
    [op start];
}

-(void)listRequestAction{
    [self HUDAction];
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/listPrayers?access_token=%@&user_id=%@",[userInfo valueForKey:@"TOKEN"],userProfileId]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([successStatus isEqualToString:@"200"]) {
            requestData = [[NSMutableArray alloc] init];
            NSDictionary *data = [responseObject objectForKey:@"message"];
            NSMutableDictionary *tempDic;
            NSMutableArray *arrayOfdata=[data valueForKey:@"prayer_request"];
            for (NSDictionary *temp in arrayOfdata)
            {
                tempDic=[NSMutableDictionary dictionary];
                
                if ([[temp valueForKey:@"prayer"] isKindOfClass:[NSDictionary class]]) {
                    [tempDic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"subject"] forKey:@"SUBJECT"];
                    [tempDic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"is_audio"] forKey:@"IS_AUDIO"];
                    [tempDic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"id"] forKey:@"PRAYERID"];
                    [tempDic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"user_id"] forKey:@"PRAYERUSERID"];
                    [tempDic setObject:[[temp objectForKey:@"prayer"]valueForKey:@"created_at"] forKey:@"TIME"];

                }else{
                    [tempDic setObject:[temp objectForKey:@"subject"] forKey:@"SUBJECT"];
                    [tempDic setObject:[temp objectForKey:@"is_audio"] forKey:@"IS_AUDIO"];
                    [tempDic setObject:[temp objectForKey:@"id"] forKey:@"PRAYERID"];
                    [tempDic setObject:[temp objectForKey:@"user_id"] forKey:@"PRAYERUSERID"];
                    [tempDic setObject:[temp objectForKey:@"created_at"] forKey:@"TIME"];

                }
               

                [requestData addObject:tempDic];
            }

            [self.tableView reloadData];
        }else if([errorState isEqualToString:@"400"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generous Prayer"
                                                            message:@"No result found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
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
        }
    }];
    [op start];
}
-(void)otherViewControllerAction:(NSIndexPath *)cellIndexPath{
    OthersViewRequestViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersViewRequestViewController"];
    //obj.datas=requestData;
    obj.prayerId=[[requestData valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row];
    obj.userId=[[requestData valueForKey:@"PRAYERUSERID"]objectAtIndex:cellIndexPath.row];
    [self.navigationController pushViewController:obj animated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListRequestCell class])];
    cell.delegate=self;
  
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    UILabel *lineLbl=[[UILabel alloc]init];
    [lineLbl setFrame:CGRectMake(0, 102
                                 , self.tableView.frame.size.width,0.5)];
    [lineLbl setBackgroundColor:sepColor];
    [cell.contentView addSubview:lineLbl];
     if ([self.swipeOrYes isEqualToString:@"no"]) {
//         [cell customArray:[NSArray arrayWithObjects:@"Pray",@"Like",@"Full Requests",nil] iPadposition:self.posArray];
//         [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:swipeWidth];
     }else{
        [cell customArray:[NSArray arrayWithObjects:@"Pray",@"Like",@"Full Requests",nil] iPadposition:self.posArray];
        [cell setRightUtilityButtons:[self leftButtons] WithButtonWidth:swipeWidth];
    }
    cell.nameLbl.text=[[requestData objectAtIndex:indexPath.row]valueForKey:@"SUBJECT"];
    if([[requestData objectAtIndex:indexPath.row]valueForKey:@"IS_AUDIO"] == 0){
       cell.statusImage.image=[UIImage imageNamed:@"audioicon.png"];
    }
    
    
    NSString *time=[CommonMethodClass relativeDateStringForDate:[[requestData valueForKey:@"TIME"]objectAtIndex:indexPath.row]];
    cell.timeLbl.text=time;
    return cell;
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    OthersViewRequestViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"OthersViewRequestViewController"];
//    [self.navigationController pushViewController:obj animated:YES];
//    
//}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSString *prayerId;
    if([self.swipeOrYes  isEqual: @"no"]){
        switch (index) {
            case 0:{
                prayerId = [NSString stringWithFormat:@"%@",[[requestData valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row]];
                [self prayRequestAction:prayerId requestFlag:@"0"];
            }
                break;
            case 1:{
                //[self otherViewControllerAction];
            }
                break;
            case 2:{
               //[self otherViewControllerAction];
            }
                break;
            default:
                break;
        }

    }else{
        switch (index) {
            case 0:{
                prayerId = [NSString stringWithFormat:@"%@",[[requestData valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row]];
                [self prayRequestAction:prayerId requestFlag:@"0"];
            }
                break;
            case 1:{
                prayerId = [NSString stringWithFormat:@"%@",[[requestData valueForKey:@"PRAYERID"]objectAtIndex:cellIndexPath.row]];
                [self prayRequestAction:prayerId requestFlag:@"3"];
            }
                break;
            case 2:{
                [self otherViewControllerAction:cellIndexPath];
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
                                                icon:[UIImage imageNamed:@"pray.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"like.png"]];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
     
                                                icon:[UIImage imageNamed:@"fullrequest.png"]];
    
    
    
    
    
    return leftUtilityButtons;
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
