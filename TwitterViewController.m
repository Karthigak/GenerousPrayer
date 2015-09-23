//
//  TwitterViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "TwitterViewController.h"
#import "SearchCell.h"
#import "CommonMethodClass.h"
#import "FHSTwitterEngine.h"
#import "CommonMethodClass.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"
typedef void(^myCompletion)(BOOL);
@interface TwitterViewController ()<UITableViewDataSource,UITableViewDelegate,FHSTwitterEngineAccessTokenDelegate>{
    MBProgressHUD *HUD;
    NSUserDefaults *defaults;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TwitterViewController

- (void)viewDidLoad {
    defaults=[NSUserDefaults standardUserDefaults];
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    self.tableView.separatorColor=sepColor;
    self.tableView.backgroundColor=[UIColor clearColor];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"Paw4hbXBrHWaxkQdIIw9tIPKg" andSecret:@"zE1H8kmQPw3csXl6g8n8QvSTCY5PO0i0VRSFiMLyhVVh2bAUaW"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        NSLog(@"%@",FHSTwitterEngine.sharedEngine.authenticatedID);
        NSLog(@"%@", FHSTwitterEngine.sharedEngine.authenticatedUsername);
        [self myMethod:^(BOOL finished) {
            if(finished){
                
            }
        }];
    }];
    [self presentViewController:loginController animated:YES completion:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
 //  http://192.237.241.156:9000/v1/sendUniqueId
}
-(void)viewDidAppear:(BOOL)animated{
//    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
//        NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
//        NSLog(@"%@",FHSTwitterEngine.sharedEngine.authenticatedID);
//        NSLog(@"%@", FHSTwitterEngine.sharedEngine.authenticatedUsername);
//        [self myMethod:^(BOOL finished) {
//            if(finished){
//                
//            }
//        }];
//    }];
//    [self presentViewController:loginController animated:YES completion:nil];
}
-(void) myMethod:(myCompletion) compblock{
    //do stuff
    [self HUDAction];
    NSString *twitterId=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/sendUniqueId?access_token=%@&unique_id=%@&type=1",[defaults valueForKey:@"TOKEN"],FHSTwitterEngine.sharedEngine.authenticatedID];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:twitterId
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"------->hgfkjfhg%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HUD hide:YES];
        
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
            
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

    compblock(YES);
}
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}
//- (void)logout {
//    [[FHSTwitterEngine sharedEngine]clearAccessToken];
//    [_theTableView reloadData];
//}
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
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    UIColor *sepColor=[CommonMethodClass pxColorWithHexValue:@"#b1eafd"];
    UILabel *lineLbl=[[UILabel alloc]init];
    [lineLbl setFrame:CGRectMake(0,134, self.tableView.frame.size.width,0.3)];
    [lineLbl setBackgroundColor:sepColor];
    [cell.contentView addSubview:lineLbl];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(void)HUDAction
{
    HUD =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD setLabelText:@"Loading..."];
    [HUD setLabelFont:[UIFont systemFontOfSize:15]];
    [HUD show:YES];
}


@end
