//
//  OthersViewRequestViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "OthersViewRequestViewController.h"
#import "Constants.h"
#import "CommonMethodClass.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "CustomAFNetworking.h"
#import "AFNetworking.h"
@interface OthersViewRequestViewController (){
    NSString *audioUrl;
    BOOL isAudio;
    MBProgressHUD *HUD;
    NSTimer *timerForPlay;
    NSUserDefaults *defaults;
    NSDictionary *prayerList;
    
    NSString *sendPrayId;
    NSString *sendUserId;

}
@property (strong, nonatomic) IBOutlet UILabel *lastPrayedLbl;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *showTimeLbl;
- (IBAction)share:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *prayedButton;
- (IBAction)prayedAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *expireLbl;
@property (strong, nonatomic) IBOutlet UIView *audioContainerView;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
- (IBAction)audionAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *titleLble;
@property (weak, nonatomic) IBOutlet UILabel *subjectLbl;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLble;
@property (weak, nonatomic) IBOutlet UILabel *prayerCount;
@property(nonatomic,strong) AVAudioPlayer*players;
@property (strong, nonatomic) IBOutlet UITextView *subjectTextView;

@end

@implementation OthersViewRequestViewController
@synthesize datas,index,players;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBorder];
    defaults=[NSUserDefaults standardUserDefaults];
    self.datas=[NSMutableArray array];
    prayerList=[NSDictionary dictionary];
    self.slider.userInteractionEnabled=NO;

    // Do any additional setup after loading the view.
}
-(void)audioPlay:(NSString *)str{
    NSString *tm=str;
    tm = [tm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    @autoreleasepool {
        NSError *error = nil;
        NSData *data=[[NSData alloc] init];
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tm] options:NSDataReadingUncached error:&error];
        players = [[AVAudioPlayer alloc] initWithData:data error:nil];
        float duration=[players duration];
        self.slider.maximumValue=duration;
        if (players!=nil) {
            [HUD hide:YES];
            players.numberOfLoops=0;
            //[players play];
        }
        else{
            NSLog(@"dagsadg");
            [HUD hide:YES];
            
        }

    }
}
-(void)viewWillAppear:(BOOL)animated{

    [self getPrayers:self.prayerId];
    self.slider.value=0.0f;
    self.previousBtn.hidden=YES;
    self.nextBtn.hidden=YES;
}
-(void)viewDidAppear:(BOOL)animated{
   

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

- (IBAction)audionAction:(id)sender {
    
    self.slider.userInteractionEnabled=YES;
    if(isAudio==NO) {
        isAudio=YES;
        [self.audioButton setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
        [players play];
        timerForPlay=[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(playerCallback:) userInfo: nil repeats: YES];
    }
    else {
        isAudio=NO;
        [self.audioButton setImage:[UIImage imageNamed:@"playicon.png"] forState:UIControlStateNormal];
        [players pause];
        [timerForPlay invalidate];

    }

}
- (void)playerCallback:(NSTimer *)timer
{
    [players updateMeters];
    float minutes = floor(players.currentTime/60);
    float seconds = players.currentTime - (minutes * 60);
    self.slider.maximumValue = [players duration];
    NSString *time = [NSString stringWithFormat:@"%0.0f:%0.0f",minutes, seconds];
    NSArray *ar=[time componentsSeparatedByString:@":"];
    NSString *min=ar[0];
    NSString *sec=ar[1];
    if (min.length ==1)
    {
        min =[NSString stringWithFormat:@"0%@",min];
    }
    if (sec.length ==1)
    {
        sec =[NSString stringWithFormat:@"0%@",sec];
    }
    [self.showTimeLbl setText:[NSString stringWithFormat:@"%@:%@",min,sec]];
    
    [self.slider setValue:players.currentTime animated:YES];
    if (players.isPlaying==NO)
    {
        
        [timerForPlay invalidate];
        [self.audioButton setImage:[UIImage imageNamed:@"playicon"] forState:UIControlStateNormal];
        self.slider.value=0.0f;
        [self.showTimeLbl setText:[NSString stringWithFormat:@"00:00"]];

    }
    
}

- (IBAction)prayedAction:(id)sender {
    NSString *pray=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@&user_id=%@&prayer_id=%@&type=%@",[defaults valueForKey:@"TOKEN"],sendUserId,sendPrayId,@"0"];
    [self HUDAction];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:pray];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            [CommonMethodClass showAlert:[responseObject valueForKey:@"message"] view:self];
             [self getPrayers:self.prayerId];
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
            // otherwise handle the error generically
            //[self handleError:error];
        }
        
    }];
    [op start];
    //[self swipeActionstype:@"0"];

}
- (IBAction)share:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.tag==0){
        [self swipeActionstype:@"1"];
    }else if (button.tag==1){
        [self sendMail:sendPrayId access_token:[defaults valueForKey:@"TOKEN"]];
    }else if (button.tag==2){
        [self swipeActionstype:@"4"];
      }

}
-(void)swipeActionstype:(NSString *)type{
    NSString *pray=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@&user_id=%@&prayer_id=%@&type=%@",[defaults valueForKey:@"TOKEN"],sendUserId,sendPrayId,type];
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
            // otherwise handle the error generically
            //[self handleError:error];
        }
        
    }];
    [op start];
    
}
-(void)sendMail:(NSString *)prayerId access_token:(NSString *)token{
    [self HUDAction];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/sendEmail?access_token=%@&&prayer_id=%@",token,prayerId];
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
        }else{
            // otherwise handle the error generically
            //[self handleError:error];
            [CommonMethodClass showAlert:[error localizedDescription] view:self];

        }
        
    }];
    [op start];
    
    
}

- (IBAction)next:(id)sender {
  
}

- (IBAction)previous:(id)sender {
}
- (IBAction)valueChanged:(id)sender{
    if (isAudio)
    {
        players.currentTime=self.slider.value;
    }
    else
    {
        players.currentTime=self.slider.value;
    }
}
-(void)getPrayers:(NSString *)prayerId{
    [self HUDAction];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/prayers/viewPrayer?access_token=%@&prayer_id=%@",[defaults valueForKey:@"TOKEN"],prayerId];
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
            prayerList=[responseObject valueForKey:@"viewPrayer"];
            [self preLoad:prayerList];
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
        }else{
            // otherwise handle the error generically
            //[self handleError:error];
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
            
        }
        
    }];
    [op start];
}
-(void)preLoad:(NSDictionary *)dic{
//        self.subjectLbl.text=[dic valueForKey:@"subject"];
    self.subjectTextView.text=[dic valueForKey:@"subject"];
        self.dateLble.text=[CommonMethodClass dateFormat:[dic valueForKey:@"created_at"]];
        self.prayerCount.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"overall_prayed_count"]];
            self.descView.text=[dic valueForKey:@"description"];
        audioUrl=[dic valueForKey:@"audio_url"];
    if ([[dic valueForKey:@"category"] isKindOfClass:[NSDictionary class]]) {
        self.categoryLbl.text=[[dic valueForKey:@"category"]valueForKey:@"name"];
    }
    self.expireLbl.text=[dic valueForKey:@"expired_date"];
    NSString *temp=[NSString stringWithFormat:@"%@",[dic valueForKey:@"is_audio"]];
    if ([temp isEqualToString:@"0"]) {
        self.audioButton.enabled=NO;
        self.audioContainerView.hidden=YES;
        //[CommonMethodClass showAlert:@"No Audio for this Prayer" view:self];
        
    }else{
        [self audioPlay:audioUrl];
    }
    if ([[dic valueForKey:@"user"] isKindOfClass:[NSDictionary class]]) {
        self.titleLble.text=[[dic valueForKey:@"user"]valueForKey:@"first_name"];
    
    }
    sendPrayId=[dic valueForKey:@"id"];
    sendUserId=[dic valueForKey:@"user_id"];

}
@end
