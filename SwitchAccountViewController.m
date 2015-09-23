//
//  SwitchAccountViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 24/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "SwitchAccountViewController.h"
#import "SwitchCell.h"
#import "CommonMethodClass.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "KLCPopup.h"
#import "ActivityViewController.h"
#import "ViewController.h"
#import "UILabel+changeAppearance.h"

@interface SwitchAccountViewController (){
    MBProgressHUD *HUD;
    NSMutableArray *userData;
    NSUserDefaults *userInfo;
    NSString *devToken;
    NSString *activeUser;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *naviView;

@end

@implementation SwitchAccountViewController
-(void)drawBorder{
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
-(void)HUDAction{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [NSUserDefaults standardUserDefaults];
    devToken = [userInfo valueForKey:@"deviceToken"];
    [self drawBorder];
    [self listSwitchUser];
    self.tableView.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    if(orientation == UIInterfaceOrientationPortrait){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            
        }
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight){
        if(isiPad){
            
            CGFloat width = CGRectGetWidth(self.view.bounds);
            CGFloat viewHeight = CGRectGetHeight(self.view.frame);
            [self.tableView setFrame:CGRectMake(0, 0, width, viewHeight)];
        }
        else{
            
        }
    }
}

-(void)listSwitchUser{
    [self HUDAction];
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/switch_account?access_token=%@&device_id=%@",[userInfo valueForKey:@"TOKEN"],devToken]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        
        if ([successStatus isEqualToString:@"200"]) {
            userData = [[NSMutableArray alloc] init];
            NSDictionary *data = [responseObject objectForKey:@"message"];
            NSMutableDictionary *tempDic;
            NSMutableArray *arrayOfdata=[data valueForKey:@"listExistingUsers"];
            for (NSDictionary *temp in arrayOfdata){
                tempDic=[NSMutableDictionary dictionary];
                [tempDic setObject:[temp objectForKey:@"first_name"] forKey:@"FIRSTNAME"];
                [tempDic setObject:[temp objectForKey:@"last_name"] forKey:@"LASTNAME"];
                [tempDic setObject:[temp objectForKey:@"email"] forKey:@"EMAIL"];
                [tempDic setObject:[temp objectForKey:@"id"] forKey:@"USERID"];
                [tempDic setObject:[temp objectForKey:@"image_url"] forKey:@"IMAGEURL"];
                [tempDic setObject:[temp objectForKey:@"is_user_active"] forKey:@"ISACTIVE"];
                [userData addObject:tempDic];
            }
            [self.tableView reloadData];
        }else if([errorState isEqualToString:@"400"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                            message:@"No result found"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD hide:YES];
        if ([error code] == kCFURLErrorNotConnectedToInternet){
            // if we can identify the error, we can present a more precise message to the user.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                            message:@"Sorry, no Internet connectivity detected. Please reconnect and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                            message:@"Sorry, no Internet connectivity detected. Please reconnect and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }];
    [op start];
    
}
-(void)loginAction{
    ViewController *loginController=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:loginController animated:YES];
}
-(void)registerAction{
    OnboardingPageviewController *registerController=[self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingPageviewController"];
    [self.navigationController pushViewController:registerController animated:YES];
  
}
-(void)activityAction{
    // Generate content view to present
    ActivityViewController *activityController=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    [self.navigationController pushViewController:activityController animated:YES];
}

-(void)switchedUser:(id)sender{
    [self HUDAction];
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSString *userId = [NSString stringWithFormat:@"%@",[[userData valueForKey:@"USERID"]objectAtIndex:indexPath.row]];
    if([activeUser isEqualToString:userId]){
        [HUD hide:YES];
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Already a user activated"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alertController addAction:cancelAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/getCurrentUserToken?access_token=%@&user_id=%@",[userInfo valueForKey:@"TOKEN"],userId]];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [HUD hide:YES];
            NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
            NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
            NSString *tokenValue=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"token"]];
            NSString *userTypeValue=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"user_type_id"]];

            if ([successStatus isEqualToString:@"200"]) {
                [userInfo setObject:tokenValue forKey:@"TOKEN"];
                [userInfo setObject:userTypeValue forKey:@"USERTYPE"];
                [self activityAction];
                //Action Occured
            }else if([errorState isEqualToString:@"400"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                                message:@"No result found"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [HUD hide:YES];
            if ([error code] == kCFURLErrorNotConnectedToInternet){
                // if we can identify the error, we can present a more precise message to the user.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                                message:@"Sorry, no Internet connectivity detected. Please reconnect and try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Generess Prayer"
                                                                message:@"Sorry, no Internet connectivity detected. Please reconnect and try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }];
        [op start];
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
    return [userData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *username = [NSString stringWithFormat:@"%@%@%@",[[userData objectAtIndex:indexPath.row]valueForKey:@"FIRSTNAME"],@" ",[[userData objectAtIndex:indexPath.row]valueForKey:@"LASTNAME"]];
    
    cell.nameLbl.text = username;
    cell.emailLbl.text = [[userData objectAtIndex:indexPath.row]valueForKey:@"EMAIL"];
    NSString *activeIcon = [NSString stringWithFormat:@"%@",[[userData objectAtIndex:indexPath.row]valueForKey:@"ISACTIVE"]];
    if([activeIcon isEqualToString: @"1"]){
       activeUser = [NSString stringWithFormat:@"%@",[[userData objectAtIndex:indexPath.row]valueForKey:@"USERID"]];

        cell.activeImage.image = [UIImage imageNamed:@"managetick.png"];
    }
    if([[[userData objectAtIndex:indexPath.row]valueForKey:@"IMAGEURL"]  isEqual: @""]){
        
    }else{
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2;
        cell.userImage.layer.masksToBounds = true;
        cell.userImage.clipsToBounds = true;
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
        
        NSURL *imageURL = [NSURL URLWithString: [[userData objectAtIndex:indexPath.row]valueForKey:@"IMAGEURL"]];
        NSURLRequest* imageRequest = [NSURLRequest requestWithURL:imageURL];
        
        [NSURLConnection sendAsynchronousRequest:imageRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data2,
                                                   NSError * error) {
                                   if (!error){
                                       cell.userImage.image = [UIImage imageWithData:data2];
                                   }
                               }];
    }
    
    if (indexPath.row==3) {
        
    }else{
        UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
        UILabel *lineLbl=[[UILabel alloc]init];
        [lineLbl setFrame:CGRectMake(0, 97, self.tableView.frame.size.width,0.5)];
        [lineLbl setBackgroundColor:sepColor];
        [cell.contentView addSubview:lineLbl];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    UIButton *addButton = [[UIButton alloc]init];
    addButton.frame= CGRectMake( self.tableView.frame.size.width/2,10, 44, 45);
    [addButton setImage:[UIImage imageNamed:@"addrequest.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [sectionFooterView addSubview:addButton];
    return sectionFooterView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self switchedUser:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}
-(void)addAction{
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 6.0;
    
    UILabel* HeaderLbl = [[UILabel alloc] init];
    HeaderLbl.translatesAutoresizingMaskIntoConstraints = NO;
    HeaderLbl.textColor = [UIColor blackColor];
    HeaderLbl.font = [UIFont boldSystemFontOfSize:17.0];
    HeaderLbl.text = @"";
    HeaderLbl.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
    
    UIButton* newUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newUserButton.translatesAutoresizingMaskIntoConstraints = NO;
    newUserButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    UIColor *orgColor=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    [newUserButton setTitleColor:orgColor forState:UIControlStateNormal];
    
    newUserButton.titleLabel.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
    [newUserButton setTitle:@"  New User" forState:UIControlStateNormal];
    newUserButton.layer.cornerRadius = 6.0;
    [newUserButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    newUserButton.tag=0;
    newUserButton.userInteractionEnabled=YES;
    newUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* exitingUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitingUserButton.translatesAutoresizingMaskIntoConstraints = NO;
    exitingUserButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    [exitingUserButton setTitleColor:orgColor forState:UIControlStateNormal];
    exitingUserButton.userInteractionEnabled=YES;
    
    exitingUserButton.titleLabel.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
    [exitingUserButton setTitle:@"Exiting User" forState:UIControlStateNormal];
    exitingUserButton.layer.cornerRadius = 6.0;
    [exitingUserButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    exitingUserButton.tag=1;
    exitingUserButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UILabel* lineLbl = [[UILabel alloc] init];
    lineLbl.translatesAutoresizingMaskIntoConstraints = NO;
    lineLbl.backgroundColor = [UIColor lightGrayColor];
    
    
    UILabel* separatorLbl = [[UILabel alloc] init];
    separatorLbl.translatesAutoresizingMaskIntoConstraints = NO;
    separatorLbl.backgroundColor = [UIColor lightGrayColor];
    
    
    [contentView addSubview:lineLbl];
    [contentView addSubview:separatorLbl];
    
    [contentView addSubview:HeaderLbl];
    [contentView addSubview:newUserButton];
    [contentView addSubview:exitingUserButton];
    
    //constraints for popup view
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, HeaderLbl,newUserButton,exitingUserButton,lineLbl,separatorLbl);
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(120)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    
    NSArray *constraint_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentView(250)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    
    [contentView addConstraints:constraint_H];
    [contentView addConstraints:constraint_W];
    
    //constraints for header label
    NSArray *HeaderLabel_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[HeaderLbl(180)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
    
    NSArray *HeaderLabel_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[HeaderLbl(40)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [HeaderLbl addConstraints:HeaderLabel_H];
    [HeaderLbl addConstraints:HeaderLabel_W];
    //constraints for organization button
    NSArray *oraganizationButton_W= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[newUserButton(185)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
    
    NSArray *oraganizationButton_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[newUserButton(30)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
    [newUserButton addConstraints:oraganizationButton_H];
    [newUserButton addConstraints:oraganizationButton_W];
    
    //constraints for lineLbl
    
    NSArray *lineLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lineLbl(185)]"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    
    NSArray *lineLbl_W= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineLbl(0.3)]"
                                                                options:0
                                                                metrics:nil
                                                                  views:views];
    [lineLbl addConstraints:lineLbl_H];
    [lineLbl addConstraints:lineLbl_W];
    
    NSArray *SepratorlineLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorLbl(0.3)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    
    NSArray *SepratorlineLbl_W= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorLbl(70)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
    [separatorLbl addConstraints:SepratorlineLbl_H];
    [separatorLbl addConstraints:SepratorlineLbl_W];
    
    
    
    //constraints for organization button
    NSArray *individualButton_W= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[exitingUserButton(185)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    
    NSArray *individualButton_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[exitingUserButton(30)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    [exitingUserButton addConstraints:individualButton_H];
    [exitingUserButton addConstraints:individualButton_W];
    
    
    
    NSArray *lineLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70)-[lineLbl(0.3)]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views];
    NSArray *line_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[lineLbl]|"
                                                              options:0
                                                              metrics:nil
                                                                views:views];
    
    [contentView addConstraints:lineLbl_V];
    [contentView addConstraints:line_H];
    
    
    NSArray *SeparaorlineLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70)-[separatorLbl(50)]-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
    NSArray *Separaorline_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(130)-[separatorLbl(0.3)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    
    [contentView addConstraints:Separaorline_H];
    [contentView addConstraints:SeparaorlineLbl_V];
    
    
    NSArray *headerLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[HeaderLbl(40)]-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    
    NSArray *headerLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[HeaderLbl]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
    
    
    
    NSArray *organization_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[newUserButton(30)]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    NSArray *organization_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-10)-[newUserButton(185)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
    
    NSArray *individual_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[exitingUserButton(30)]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    NSArray *individual_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(125)-[exitingUserButton(185)]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
    [contentView addConstraints:headerLbl_V];
    [contentView addConstraints:headerLbl_H];
    [contentView addConstraints:organization_V];
    [contentView addConstraints:organization_H];
    
    [contentView addConstraints:individual_V];
    [contentView addConstraints:individual_H];
    
    // Show in popup
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,
                                               (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                            showType:KLCPopupShowTypeSlideInFromTop
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeBounceOutToBottom
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:YES];
    [popup showWithLayout:layout];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
