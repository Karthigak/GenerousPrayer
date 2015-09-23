//
//  TimerScreen.m
//  GeneresPrayer
//
//  Created by Anbu on 17/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "TimerScreen.h"
#import "TimerCell.h"
#import <AVKit/AVPlayerViewController.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "MBProgressHUD.h"
#import "CommonMethodClass.h"
#import "AFNetworking/AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UILabel+changeAppearance.h"
#import "PrayCompletedViewController.h"
@interface TimerScreen ()
{
    MBProgressHUD *HUD;
    int totlCount;
    BOOL isPlayGreen;
    NSInteger value;
    
    NSArray *audioUrls;
    
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    int total;
    
    
    int betWeenMintue;
    int betweeneconds;
    int totalOne;

    NSTimer *timerForPlay;
    NSTimer *timerForBetween;
    NSUserDefaults *defaults;

}
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *betweenTimeLbl;
@property(nonatomic,strong) AVAudioPlayer*players;
@end

@implementation TimerScreen
@synthesize players;
-(void)audioPlay:(NSString *)str{
    [self HUDAction];
    NSString *tm=str;
    players=nil;
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
    UIColor *col=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    self.circularSlider.thumbTintColor=col;
    self.circularSlider.maximumTrackTintColor=[UIColor lightTextColor];
    self.circularSlider.minimumTrackTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Rec_20.png"]];
    self.circularSlider.userInteractionEnabled=YES;
    self.slider.thumbTintColor=col;
    
}
-(void)betweenDuration{
    if([self.betweenPrayer isEqualToString:@"1.15 mins"] || [self.betweenPrayer isEqualToString:@"1.30 mins"] || [self.betweenPrayer isEqualToString:@"1.45 mins"])
    {
        self.betweenPrayer=[NSString stringWithFormat:@"%@",self.betweenPrayer];
        NSArray *arr=[self.betweenPrayer componentsSeparatedByString:@" "];
        NSString *temp;
        temp=[arr objectAtIndex:0];
        NSArray *arrs=[self.betweenPrayer componentsSeparatedByString:@"."];
        int hours=[[arrs objectAtIndex:0]intValue];
        int minutes=[[arrs objectAtIndex:1]intValue];
        betWeenMintue=(int)hours;
        betweeneconds=(int)minutes;
        totalOne= minutes + (betWeenMintue * 60);
        self.betweenTimeLbl.text = [NSString stringWithFormat:@"00:%d:%d",betWeenMintue,betweeneconds];
    }else if([self.betweenPrayer isEqualToString:@"30 Secs"] || [self.betweenPrayer isEqualToString:@"45 Secs"]){
        self.betweenPrayer=[NSString stringWithFormat:@"%@",self.betweenPrayer];
        NSArray *arr=[self.betweenPrayer componentsSeparatedByString:@" "];
        NSString *temp;
        temp=[arr objectAtIndex:0];
        totalOne=[temp intValue];
        self.betweenTimeLbl.text = [NSString stringWithFormat:@"00:00:%d",betWeenMintue];
    }else{
        self.betweenPrayer=[NSString stringWithFormat:@"%@",self.betweenPrayer];
        NSArray *arr=[self.betweenPrayer componentsSeparatedByString:@" "];
        NSString *temp;
       temp=[arr objectAtIndex:0];
        totalOne=[temp intValue]*60;
        self.betweenTimeLbl.text = [NSString stringWithFormat:@"00:00:%d",betWeenMintue];
    }
    NSLog(@"%@",self.betweenPrayer);
    

}
-(void)viewDidAppear:(BOOL)animated{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    timerForBetween=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredBetwen) userInfo:nil repeats:YES];
}

int i=0;
-(void)timerFiredBetwen
{

    self.circularSlider.value=i;
    if(totalOne > 0 ){
        i++;
        totalOne -- ;
        int  hours = totalOne / 3600;
        int   minutes = (totalOne % 3600) / 60;
        int seconds = (totalOne %3600) % 60;
        self.betweenTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else{
        [timerForBetween invalidate];
//        self.circularSlider.value=0.0;
        [self next:nil];
        NSLog(@"time is over");
    }
    
}

//timer for total time duration counting
int j=0;
-(void)timerFired
{
    if(total > 0 ){
        j++;
        total -- ;
        int  hours = total / 3600;
        int   minutes = (total % 3600) / 60;
        int seconds = (total %3600) % 60;
        self.showTotalTimer.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
    else{
        //total = 16925;
        NSLog(@"time is over");
        //[self goNext];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.totalPrayCount.text=[NSString stringWithFormat:@"  1"];
    defaults=[NSUserDefaults standardUserDefaults];
//    [self.circularSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
    [self setGradientView:self.gradientView];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:self.totalPrayTimer];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    self.showTotalTimer.text =[NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)minute];
    currMinute=(int)hour;
    currSeconds=(int)minute;
    total= (currMinute * 60 * 60) + (currSeconds * 60);
    self.slider.value=0.0;
    NSLog(@"%@",_datas);
    NSLog(@"%@",self.totalPrayTimer);
    self.circularSlider.maximumValue=total;
    [self betweenDuration];
    self.peopleLbl.text=[NSString stringWithFormat:@"Prayed by %@ people",[[self.datas valueForKey:@"OVERALLPRAYEDCOUNT"]objectAtIndex:value]];
    self.subjectLble.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"SUBJECT"]objectAtIndex:value]];
    self.nameLbl.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"FIRSTNAME"]objectAtIndex:value]];
  self.descriptionTextView.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"DESCRIPTION"]objectAtIndex:value]];
    [self sendMail:[[self.datas valueForKey:@"ID"]objectAtIndex:value] access_token:[defaults valueForKey:@"TOKEN"]];
    NSString *audioUrlValue = [NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"AUDIOURL"]objectAtIndex:value]];
    if ([audioUrlValue isEqualToString:@""]) {
        self.audioView.hidden = YES;
    }else{
        self.audioView.hidden = NO;
    }
    self.subjectLble.preferredMaxLayoutWidth = 200;
    [self.subjectLble setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.subjectLble setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.subjectLble setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (IBAction)updateProgress:(UISlider *)sender {
    [self.circularSlider setValue:sender.value];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Are you sure want to quit Prayer?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self goNext];
                                   NSLog(@"OK action");
                                   
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)goNext{
    NSLog(@"%d",j);
    [timerForBetween invalidate];
    PrayCompletedViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"PrayCompletedViewController"];
    NSLog(@"%@",self.showTotalTimer.text);
    obj.timerString=self.showTotalTimer.text;
    obj.totalRequest=[NSString stringWithFormat:@"%lu",(unsigned long)[self.datas count]];
    obj.totalPrayer=self.totalPrayCount.text;
    obj.datas=self.datas;
    if (j>60) {
        NSLog(@"%d",j/60);
        j=j/60;
        NSString *temp=[NSString stringWithFormat:@"%d",j];
        obj.totalPrayedTime=[NSString stringWithFormat:@"You have just prayed for %@ minutes",temp];
    }else{
        NSString *temp=[NSString stringWithFormat:@"%d",j];
        obj.totalPrayedTime=[NSString stringWithFormat:@"You have just prayed for %@ seconds",temp];
        
    }
    [self.navigationController pushViewController:obj animated:YES];
}
- (IBAction)previousAction:(id)sender {
   // [timerForBetween invalidate];
    value=value-1;
    if(value<[self.datas count])
    {
         [timerForBetween invalidate];
        [self betweenDuration];
        NSString *count=self.totalPrayCount.text;
        self.totalPrayCount.text=[NSString stringWithFormat:@"  %d",[count intValue]+1];
        timerForBetween=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredBetwen) userInfo:nil repeats:YES];
        self.peopleLbl.text=[NSString stringWithFormat:@"Prayed by %@ people",[[self.datas valueForKey:@"OVERALLPRAYEDCOUNT"]objectAtIndex:value]];
        self.subjectLble.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"SUBJECT"]objectAtIndex:value]];
        self.nameLbl.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"FIRSTNAME"]objectAtIndex:value]];
        self.descriptionTextView.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"DESCRIPTION"]objectAtIndex:value]];
        [self sendMail:[[self.datas valueForKey:@"ID"]objectAtIndex:value] access_token:[defaults valueForKey:@"TOKEN"]];
    }else{
        value=value+1;
        [CommonMethodClass showAlert:@"No more list" view:self];

    }

}
- (IBAction)next:(id)sender {
    value=value+1;
    if(value<[self.datas count])
    {
        [timerForBetween invalidate];
        NSString *count=self.totalPrayCount.text;
        self.totalPrayCount.text=[NSString stringWithFormat:@"  %d",[count intValue]+1];
        timerForBetween=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredBetwen) userInfo:nil repeats:YES];
        self.peopleLbl.text=[NSString stringWithFormat:@"Prayed by %@ people",[[self.datas valueForKey:@"OVERALLPRAYEDCOUNT"]objectAtIndex:value]];
        self.subjectLble.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"SUBJECT"]objectAtIndex:value]];
        self.nameLbl.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"FIRSTNAME"]objectAtIndex:value]];
        self.descriptionTextView.text=[NSString stringWithFormat:@"%@",[[self.datas valueForKey:@"DESCRIPTION"]objectAtIndex:value]];
        [self sendMail:[[self.datas valueForKey:@"ID"]objectAtIndex:value] access_token:[defaults valueForKey:@"TOKEN"]];
        [self betweenDuration];
    }else{
        value=value-1;
        [CommonMethodClass showAlert:@"No more list" view:self];
    }

}
- (IBAction)playPause:(id)sender {
    
    if (isPlayGreen==NO) {
        isPlayGreen=YES;
        [timerForBetween invalidate];
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];

    }else{
        isPlayGreen=NO;
        timerForBetween=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFiredBetwen) userInfo:nil repeats:YES];
   [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)playGreen:(id)sender {
    UIColor *color=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    self.slider.thumbTintColor=color;
    NSString *audioUrl=[[self.datas valueForKey:@"AUDIOURL"]objectAtIndex:value];
    if ([audioUrl isEqualToString:@""]) {
        [CommonMethodClass showAlert:@"No audio found for this prayer" view:self];
    }else{
        if (isPlayGreen==NO) {
            isPlayGreen=YES;
            if ([players isPlaying]) {
            }else{
            }
            [self audioPlay:audioUrl];
            [players play];
            [self.playGrrenButton setImage:[UIImage imageNamed:@"pausegreen.png"] forState:UIControlStateNormal];
            timerForPlay=[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(playerCallback:) userInfo: nil repeats: YES];
        }else{
            isPlayGreen=NO;
            [self.playGrrenButton setImage:[UIImage imageNamed:@"playgreen.png"] forState:UIControlStateNormal];
            [players pause];
            [timerForPlay invalidate];
        }
    }
}
- (IBAction)valueChanged:(id)sender {
    if (isPlayGreen){
        players.currentTime=self.slider.value;
    }else{
        players.currentTime=self.slider.value;
    }
}
- (IBAction)share:(id)sender {
    UIButton *button=(UIButton *)sender;
    if (button.tag==0) {
        [self HUDAction];
        NSString *token=[defaults valueForKey:@"TOKEN"];
        NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@&user_id=%@&prayer_id=%@&type=1",token,[[self.datas valueForKey:@"USERID"]objectAtIndex:value],[[self.datas valueForKey:@"ID"]objectAtIndex:value]];
        NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp];
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
            }else if([error code]==kCFURLErrorCannotConnectToHost){
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }
            else{
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }
        }];
        [op start];
    }else if (button.tag==1){
        [self sendMail:[[self.datas valueForKey:@"ID"]objectAtIndex:value] access_token:[defaults valueForKey:@"TOKEN"]];
        }else if (button.tag==2){
        [self HUDAction];
        NSString *token=[defaults valueForKey:@"TOKEN"];
        NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/UserRequestAction?access_token=%@&user_id=%@&prayer_id=%@&type=4",token,[[self.datas valueForKey:@"USERID"]objectAtIndex:value],[[self.datas valueForKey:@"ID"]objectAtIndex:value]];
        NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp];
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
            }
            else{
                [CommonMethodClass showAlert:[error localizedDescription] view:self];
            }
        }];
        [op start];
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
    if (min.length ==1){
        min =[NSString stringWithFormat:@"0%@",min];
    }if (sec.length ==1){
        sec =[NSString stringWithFormat:@"0%@",sec];
    }
    [self.timeLbl setText:[NSString stringWithFormat:@"%@:%@",min,sec]];
    [self.slider setValue:players.currentTime animated:YES];
    if (players.isPlaying==NO){
        [timerForPlay invalidate];
        [self.playGrrenButton setImage:[UIImage imageNamed:@"playgreen.png"] forState:UIControlStateNormal];
        self.slider.value=0.0f;
    }
}
-(void)setGradientView:(UIView *)gradientView{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientView.bounds;
    UIColor *startColor=[CommonMethodClass pxColorWithHexValue:@"03070e"];
    UIColor *endColor=[CommonMethodClass pxColorWithHexValue:@"0f192f"];
    gradient.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
    [gradientView.layer insertSublayer:gradient atIndex:0];
}
-(void)sendMail:(NSString *)prayerId access_token:(NSString *)token{
    [self HUDAction];
    NSString *temp=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/sendEmail?access_token=%@&&prayer_id=%@",token,prayerId];
    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:temp];
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
            [CommonMethodClass showAlert:[error localizedDescription] view:self];
        }
    }];
    [op start];
    
}
@end
