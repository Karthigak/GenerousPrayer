//
//  TermsAndConditionViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 03/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "TermsAndConditionViewController.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"

@interface TermsAndConditionViewController (){
    MBProgressHUD *HUD;
    NSString *contentValue;
}
- (IBAction)back:(id)sender;

@end

@implementation TermsAndConditionViewController
@synthesize contentTextView;
-(void)drawView{
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
    [self drawView];
    [self getTermsContent];
    // Do any additional setup after loading the view.
}

-(void)getTermsContent{
    [self HUDAction];
    NSMutableURLRequest* request=[CustomAFNetworking getMethodWithUrl:[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/regulations/termsAndCondition"]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUD hide:YES];
        NSString *errorState=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        NSString *successStatus=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        if ([successStatus isEqualToString:@"200"]) {
            NSDictionary *data = [responseObject objectForKey:@"message"];
            contentTextView.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"content"]];
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
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
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
