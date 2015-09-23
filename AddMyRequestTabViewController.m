//
//  AddMyRequestTabViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "Constants.h"
#import "RequestTabViewController.h"
#import "ActivityViewController.h"
#import "PrayerTimerViewController.h"
#import "MyProfileViewController.h"
#import "NotificationTabViewController.h"
#import "AddMyRequestTabViewController.h"
#import "AddMyRequestCell.h"
#import "CommonMethodClass.h"
#import "CALayer+bordercolor.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "CustomAFNetworking.h"
#import "UILabel+changeAppearance.h"
#import "MBProgressHUD.h"

@interface AddMyRequestTabViewController ()<NIDropDownDelegate,UITextViewDelegate,LGActionSheetDelegate>
{
    NIDropDown *dropDown;
    NSString *selectedString;
    NSMutableArray *emailAddress;
    NSMutableArray *categoryList;
    NSString *expireDate;
    NSString *urgentSrting;
    BOOL isCategoryClicked;
    BOOL isEmailClicked;
    BOOL isUrgentClicked;
    BOOL isPlay;
    MBProgressHUD *HUD;

    
    BOOL isAnonmous;
    BOOL isPublic;
    BOOL isFriends;
    BOOL isMine;

    NSString *StatusString;
    
    
    BOOL isCancel;
    
    //audio reference
    NSString *playingstatus;
    NSTimer *timerForPlay;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    
    float Pitch;
    NSTimer *timerForPitch;
    NSDictionary *postData;
    NSMutableDictionary *passData;
    NSString *categoryId;
    
    BOOL isAnonmousLbl;
    BOOL isPublicLbl;
    BOOL isFriendsLbl;
    BOOL isMineLbl;
    BOOL isNoAudio;
    BOOL isStop;


}
@property (strong, nonatomic) IBOutlet UITextView *descText;
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *naviLbl;
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *anonymousLbl;
@property (strong, nonatomic) IBOutlet UILabel *publicLbl;
@property (strong, nonatomic) IBOutlet UILabel *friendsLbl;
- (IBAction)stopRecord:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *mineLbl;


- (IBAction)sliderChanged:(id)sender;


@end

@implementation AddMyRequestTabViewController
@synthesize subjectTxt,canelBtn,categoryBtn,deleteAudioBtn,descText,expireButton,expireLbl,naviLbl,naviView,playBtn,showTimeLbl,startRecordBtn,tapButton,scrollView;

-(void)drawView
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
    [self preLoad];
    urgentSrting=@"0";
    //audio init code
    playingstatus=@"Play";
    self.slider.minimumValue=0;
    self.slider.maximumValue=30;
    [self.slider setMinimumTrackTintColor:[UIColor whiteColor]];
    [self.slider setMaximumTrackTintColor:[UIColor whiteColor]];
//    [self.slider setThumbTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    [self listCategory];
    self.slider.userInteractionEnabled=NO;


}

-(void)setUpTapGesture{
    UITapGestureRecognizer *anonymousLbl =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getstureAnonmous)];
    anonymousLbl.numberOfTapsRequired=1;
    self.anonymousLbl.userInteractionEnabled=YES;
    [self.anonymousLbl addGestureRecognizer:anonymousLbl];
    
    UITapGestureRecognizer *publicLbl =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePublic)];
    publicLbl.numberOfTapsRequired=1;
    self.publicLbl.userInteractionEnabled=YES;
    [self.publicLbl addGestureRecognizer:publicLbl];
    
    UITapGestureRecognizer *friendsLbl =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureFriends)];
    friendsLbl.numberOfTapsRequired=1;
    self.friendsLbl.userInteractionEnabled=YES;
    [self.friendsLbl addGestureRecognizer:friendsLbl];
    
    UITapGestureRecognizer *mineLbl =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureMine)];
    mineLbl.numberOfTapsRequired=1;
    self.mineLbl.userInteractionEnabled=YES;
    [self.mineLbl addGestureRecognizer:mineLbl];
}
- (void)viewDidLoad {
    self.slider.thumbTintColor=[UIColor clearColor];
    defaults=[NSUserDefaults standardUserDefaults];
    postData=[NSDictionary dictionary];
    passData=[NSMutableDictionary dictionary];
    isPlay=YES;
    [super viewDidLoad];
    selectedString=@"Categories";
    self.tableView.backgroundColor=[UIColor clearColor];
    dropDown = [[NIDropDown alloc]init];
    dropDown.delegate = self;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker)];
    tapGesture.numberOfTapsRequired=1;
    self.expireLbl.userInteractionEnabled=YES;
    [self.expireLbl addGestureRecognizer:tapGesture];
    [self tab];
    [self drawView];
    [self drawLable];
    emailAddress=[NSMutableArray array];
    categoryList=[NSMutableArray array];
    [self setUpTapGesture];
    self.deleteAudioBtn.hidden=YES;
    self.categoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.categoryBtn setTitle:[NSString stringWithFormat:@"  Category"] forState:UIControlStateNormal];
    subjectTxt.attributedPlaceholder =[self PlaceHolderTextApperance:@"Subject" color:[UIColor whiteColor]];
    

    self.slider.thumbTintColor=[UIColor clearColor];
    self.deleteAudioBtn.hidden=YES;
    self.tapButton.enabled=NO;
    self.playBtn.enabled=NO;
    // Do any additional setup after loading the view.
}
-(NSAttributedString *)PlaceHolderTextApperance:(NSString *)str color:(UIColor *)color{
    
    
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
                                                        NSFontAttributeName : [UIFont fontWithName:@"Myriad Pro" size:17.0]
                                                        }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
}
-(void)selectedString:(NSString *)text
{
    selectedString=text;
   [self.categoryBtn setTitle:[NSString stringWithFormat:@"  %@",selectedString] forState:UIControlStateNormal];
    
}
-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    viewHeight = CGRectGetHeight(self.view.frame);
    //[self.tableView setFrame:CGRectMake(0, 62, width, viewHeight-50)];
    
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
    
    [tabBar addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    tabBar.tag=1;
    UIColor *dividerColor=[CommonMethodClass pxColorWithHexValue:@"#CCF3FC"];
    tabBar.verticalDividerColor =dividerColor;
    
    
    if (isiPad) {
        tabBar.verticalDividerWidth = 1.0f;
        
    }
    else
    {
        tabBar.verticalDividerWidth = 0.5f;
        
    }
    tabBar.selectedSegmentIndex=1;
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

- (IBAction)backAction:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    [audioRecorder pause];
    if (isCancel==NO) {
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Are you sure want to cancel Request?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [audioRecorder record];

                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [self stop];
                                       [self.navigationController popViewControllerAnimated:YES];

                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}


- (IBAction)showDatePicker:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    [self datePicker];
}
- (IBAction)showCategoryList:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    NSMutableArray *temp=[NSMutableArray array];
    for (int i=0; i<[categoryList count]; i++) {
        [temp addObject:[[categoryList objectAtIndex:i]valueForKey:@"NAME"]];
    }
    if(isCategoryClicked==NO) {
        CGFloat f = 150;
        [dropDown showDropDown:sender :&f :temp :nil :@"down"];
        isCategoryClicked=YES;
    }
    else {
        [dropDown hideDropDown:sender];
        isCategoryClicked=NO;
        
    }
}
- (IBAction)urgentAction:(id)sender {
    if(isUrgentClicked==NO) {
        [self.urgentButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        urgentSrting=@"1";
        isUrgentClicked=YES;
    }
    else {
        [self.urgentButton setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        urgentSrting=@"0";
        isUrgentClicked=NO;
        
    }
    
}
- (IBAction)playAudio:(id)sender {
    UIColor *col=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
    self.slider.thumbTintColor=col;
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    isCancel=YES;
    [self.startRecordBtn setEnabled:NO];
    [self.startRecordBtn setImage:[UIImage imageNamed:@"mikeactive"] forState:UIControlStateNormal];
    if([playingstatus isEqualToString:@"Play"])
    {
        [self.playBtn setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
        [audioPlayer play];
        NSLog(@"playing");
        playingstatus = @"Playing";
        timerForPlay=[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(playerCallback:) userInfo: nil repeats: YES];
    }
    else
    {
        [self.playBtn setImage:[UIImage imageNamed:@"playicon"] forState:UIControlStateNormal];
        [audioPlayer pause];
        playingstatus = @"Play";
        [timerForPlay invalidate];
    }
}
-(void)selectedIndex:(int)index{
    NSLog(@"%d",index);
    categoryId=[[categoryList objectAtIndex:index]valueForKey:@"ID"];
}
- (IBAction)sliderChanged:(id)sender
{
    if ([playingstatus isEqualToString:@"Playing"])
    {
        audioPlayer.currentTime=self.slider.value;
    }
    else
    {
        audioPlayer.currentTime=self.slider.value;
    }
}

- (IBAction)startRecord:(id)sender {
   
    [self doneTyping];

       self.slider.userInteractionEnabled=NO;
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    isCancel=YES;
    [self.startRecordBtn setImage:[UIImage imageNamed:@"mikeactive"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
 
    [self.tapButton  setTitle:@"Recording..." forState:UIControlStateNormal];
    [self.slider setThumbTintColor:[UIColor clearColor]];
    NSLog(@"startRecording");
    audioRecorder = nil;
    NSMutableDictionary *recordSettings =[[NSMutableDictionary alloc]init];
    AVAudioSession *audioSession =[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [recordSettings setObject:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.meteringEnabled = YES;
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        
        
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }else {
        int errorCode = CFSwapInt32HostToBig ((int)[error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
}
- (void)playerCallback:(NSTimer *)timer
{
    [audioPlayer updateMeters];
    float minutes = floor(audioPlayer.currentTime/60);
    float seconds = audioPlayer.currentTime - (minutes * 60);
    self.slider.maximumValue = [audioPlayer duration];
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
    //[self.showTimeLbl setText:[NSString stringWithFormat:@"%@:%@ secs",min,sec]];
    NSString *times = [NSString stringWithFormat:@"%@.%@",min, sec];
    [self.showTimeLbl setText:[NSString stringWithFormat:@"%@ secs", times]];

    [self.slider setValue:audioPlayer.currentTime animated:YES];
    if (audioPlayer.isPlaying==NO)
    {
        [timerForPlay invalidate];
        [self.startRecordBtn setEnabled:YES];
        playingstatus = @"Play";
        [self.startRecordBtn setImage:[UIImage imageNamed:@"mike"] forState:UIControlStateNormal];
        [self.playBtn setImage:[UIImage imageNamed:@"playicon"] forState:UIControlStateNormal];
        [self.slider setThumbTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        self.slider.value=0.0f;
        [self.showTimeLbl setText:[NSString stringWithFormat:@"0:00 secs"]];

    }
    
}
- (void)levelTimerCallback:(NSTimer *)timer {
    [audioRecorder updateMeters];
    NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
    
    float linear = pow (10, [audioRecorder peakPowerForChannel:0] / 20);
    NSLog(@"linear===%f",linear);
    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0] / 20);
    NSLog(@"linear1===%f",linear1);
    if (linear1>0.03) {
        
        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
    }
    else {
        
        Pitch = 0.0;
    }
    //    self.slider.minimumValue=0;
    //    self.slider.maximumValue=30;
    
    self.slider.value=audioRecorder.currentTime;
    //Pitch =linear1;
    NSLog(@"Pitch==%f",Pitch);
    float minutes = floor(audioRecorder.currentTime/60);
    float seconds = audioRecorder.currentTime - (minutes * 60);
    
    NSString *time = [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];
    if ([time isEqualToString:@"0.30"]) {
        self.startRecordBtn.enabled=NO;
        self.showTimeLbl.text=@"0.00 secs";
       // self.showTimeLbl.hidden=YES;
        self.deleteAudioBtn.hidden=NO;
        [self.startRecordBtn setImage:[UIImage imageNamed:@"mike"] forState:UIControlStateNormal];
        [self.slider setThumbTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];

        [self.tapButton  setHidden:YES];
        
        // Init audio with playback capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                                NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        NSString *soundFilePath = [docsDir
                                   stringByAppendingPathComponent:@"recordTest.mp4"];
        
        NSURL *url = [NSURL fileURLWithPath:soundFilePath];
       
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        
        [self stop];
    }
    [self.showTimeLbl setText:[NSString stringWithFormat:@"%@ secs", time]];
    NSLog(@"recording");
    
}

- (IBAction)stop {
    self.playBtn.enabled=YES;
    self.startRecordBtn.enabled=YES;
    self.slider.userInteractionEnabled=YES;

    [self.tapButton  setTitle:@"Tap to Record" forState:UIControlStateNormal];
    [audioRecorder stop];
    NSLog(@"stopped");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [timerForPitch invalidate];
    timerForPitch = nil;
    self.slider.value = 0.0;
}

- (IBAction)deleteAudion:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    if (isCancel==NO) {
        
    }else{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Are you sure want to cancel Request?"
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
                                       NSLog(@"OK action");
                                       self.startRecordBtn.enabled=YES;
                                       self.showTimeLbl.hidden=NO;
                                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                       if ([paths count] > 0)
                                       {
                                           NSError *error = nil;
                                           NSFileManager *fileManager = [NSFileManager defaultManager];
                                           
                                           // Print out the path to verify we are in the right place
                                           NSString *directory = [paths objectAtIndex:0];
                                           NSLog(@"Directory: %@", directory);
                                           
                                           // For each file in the directory, create full path and delete the file
                                           for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error])
                                           {
                                               
                                               if ([file isEqualToString:@"recordTest.mp4"]) {
                                                   NSString *filePath = [directory stringByAppendingPathComponent:file];
                                                   NSLog(@"File : %@", filePath);
                                                   
                                                   BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
                                                   
                                                   if (fileDeleted != YES || error != nil)
                                                   {
                                                       // Deal with the error...
                                                   }
                                                   NSLog(@"File Dleted");
                                                   
                                                   
                                               }
                                               self.deleteAudioBtn.hidden=YES;
                                               self.tapButton.hidden=NO;
                                               self.tapButton.enabled=NO;
                                               [self.startRecordBtn setImage:[UIImage imageNamed:@"mike"] forState:UIControlStateNormal];
                                               self.slider.value=0.0f;
                                               [audioPlayer stop];
                                               [self.tapButton  setTitle:@"Tap to Record" forState:UIControlStateNormal];
                                               self.showTimeLbl.hidden=NO;
                                               self.showTimeLbl.text=@"0.00";
                                               
                                           }
                                       }
                                       

                                       
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

   }
-(NSData *)audioData{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.mp4"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    NSData *audioData=[NSData dataWithContentsOfURL:url];
    return audioData;
}
- (BOOL)validate{
    if (self.subjectTxt.text.length == 0){
        return [self setValidationMsg:@"Please populate subject"];
    }else if (categoryId == nil){
        return [self setValidationMsg:@"Please populate category"];
    }else if ([self.expireLbl.text isEqualToString: @""]){
        return [self setValidationMsg:@"Please populate expiration date"];
    }else if (self.descriptionTextView.text.length == 0){
        return [self setValidationMsg:@"Please populate description"];
    }else if (StatusString == NULL){
        return [self setValidationMsg:@"Please select description"];
    }
    return true;
}
- (BOOL)setValidationMsg:(NSString *)msg{
    [CommonMethodClass showAlert:msg view:self];
    return false;
}
-(void)post{
    [self stop];
    NSString *subject=self.subjectTxt.text;
    NSString *expire=self.expireLbl.text;
    NSString *isUrgent=urgentSrting;
    NSString *description=self.descriptionTextView.text;
    NSData *audioFile=[self audioData];
    if (audioFile==nil) {
        [passData setObject:@"" forKey:@"audio"];
        [passData setObject:@"0" forKey:@"is_audio"];
    }else{
        [passData setObject:@"1" forKey:@"is_audio"];
    }
    [passData setObject:subject forKey:@"subject"];
    if (categoryId==nil) {
        [passData setObject:@"" forKey:@"category_id"];
        
    }else{
        [passData setObject:categoryId forKey:@"category_id"];
    }
    [passData setObject:isUrgent forKey:@"is_urgent"];
    [passData setObject:expire forKey:@"expired_date"];
    [passData setObject:description forKey:@"description"];
    [passData setObject:@"2" forKey:@"prayer_type_id"];
    [passData setObject:StatusString forKey:@"prayer_access_id"];
    postData=@{@"access_token":[defaults valueForKey:@"TOKEN"],@"prayer":passData};
    [self HUDAction];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://192.237.241.156:9000/v1/prayers/addPrayerRequest" parameters:postData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (audioFile==nil) {
            [formData appendPartWithFileData:[[NSData alloc]init]
                                        name:@"prayer[audio]" fileName:@"NoAudio" mimeType:@"audio/mp4"];
        }else{
            [formData appendPartWithFileData:audioFile name:@"prayer[audio]" fileName:@"testMine.mp4" mimeType:@"audio/mp4"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
        NSLog(@"Success: %@", responseObject);
        NSString *status=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"status"]];
        NSString *error_code=[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"error_code"]];
        if([status isEqualToString:@"200"]){
            
            [self showAlertPray:[responseObject valueForKey:@"message"] view:self];
            
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
        }                                   }];
    

}
- (IBAction)addRequest:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    UIAlertController *alertController;
    //Validation section
    if([self validate]){
        
    if ([audioRecorder isRecording]) {
        //[self stop];
        isNoAudio=YES;
        [audioRecorder pause];
        [timerForPitch invalidate];
        alertController = [UIAlertController
                           alertControllerWithTitle:@""
                           message:@"Are you sure want to complete the Recording and Request?"
                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (isNoAudio==YES) {
                                               [audioRecorder record];
                                               timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
                                               
                                           }else{
                                               
                                           }
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [self post];
                                       
                                   }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(audioRecorder==nil){
        isNoAudio=NO;
        alertController = [UIAlertController
                           alertControllerWithTitle:@""
                           message:@"Are you sure want to send without audio file?"
                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           if (isNoAudio==YES) {
                                               [audioRecorder record];
                                               timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
                                               
                                           }else{
                                               
                                           }
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [self post];
                                       
                                   }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self post];
    }


    }
}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)cancelButton:(id)sender {
    [self.descriptionTextView resignFirstResponder];
    [activeField resignFirstResponder];
    [audioRecorder pause];
    if (isCancel==NO) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Are you sure want to cancel Request?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [audioRecorder record];
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       [self stop];
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
        UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
        [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,-150,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
    }
    
    [self.view endEditing:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark :Scroll up the current screen position when keyboard appear
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIView *accView = [self createInputAccessoryView];
    [textField setInputAccessoryView:accView];
    return TRUE;
}

#pragma mark :Scroll up the current screen position when keyboard appear
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self doFramBoundUp:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [self doFramBoundsDown];
}

-(void)doFramBoundUp :(UITextField *)textField{
    CGRect textFieldRect;
    activeField = textField;
    textFieldRect = [self.view convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) *viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0){
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0){
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown){
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }else{
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //viewFrame.origin.x -= animatedDistance+25;
        if(IS_OS_8_OR_LATER){
            viewFrame.origin.y -= animatedDistance+25;
        }else{
            viewFrame.origin.x -= animatedDistance+25;
        }
        
    }else{
        viewFrame.origin.y -= animatedDistance;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)doFramBoundsDown{
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    
    CGRect viewFrame = self.view.frame;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        //viewFrame.origin.x += animatedDistance+25;
        if(IS_OS_8_OR_LATER){
            viewFrame.origin.y += animatedDistance+25;
        }else{
            viewFrame.origin.x += animatedDistance+25;
        }
        
    }else{
        viewFrame.origin.y += animatedDistance;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - keyboard
-(UIView*)createInputAccessoryView{
    UIButton *btnDone;
    UIView *inputAccView;
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 20.0)];
    [inputAccView setBackgroundColor:[UIColor clearColor]];
    //[inputAccView setAlpha: 0.0];
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [btnDone setFrame:CGRectMake(962.0,-36.0f, 90.0f, 70.0f)];
    }else if(IS_IPHONE_6_PLUS){
        [btnDone setFrame:CGRectMake(360.0,-36.0f, 90.0f, 60.0f)];
    }else if(IS_IPHONE_6){
        [btnDone setFrame:CGRectMake(315.0,-36.0f, 90.0f, 60.0f)];
    }else{
        [btnDone setFrame:CGRectMake(265.0,-36.0f, 80.0f, 60.0f)];
    }   UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"down.png"]];
    btnDone.backgroundColor = background;
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    [inputAccView addSubview:btnDone];
    return inputAccView;
}
-(void)doneTyping{
    // When the "done" button is tapped, the keyboard should go away.
    // That simply means that we just have to resign our first responder.
    [activeField resignFirstResponder];
    
}


#pragma category list
-(void)listCategory{
    NSString *string=[NSString stringWithFormat:@"http://192.237.241.156:9000/v1/categories?access_token=%@",[defaults valueForKey:@"TOKEN"]];

    NSMutableURLRequest*   request=[CustomAFNetworking getMethodWithUrl:string
                                    ];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
        NSMutableDictionary *dict;
        for (NSArray *dic in  [responseObject valueForKey:@"message"]) {
            dict=[NSMutableDictionary dictionary];
            [dict setObject:[dic valueForKey:@"name"] forKey:@"NAME"];
            [dict setObject:[dic valueForKey:@"id"] forKey:@"ID"];
            [categoryList addObject:dict];
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([error code] == kCFURLErrorNotConnectedToInternet)
        {
        }else if([error code]==kCFURLErrorTimedOut){
            [self showAlert:[error localizedDescription]];
        }else if([error code]==kCFURLErrorBadServerResponse){
            [self showAlert:[error localizedDescription]];
        }
        else
        {
            // otherwise handle the error generically
            //[self handleError:error];
        }
    }];
    [op start];
    
    
}


#pragma choose date from date picker

- (void)actionSheet:(LGActionSheet *)actionSheet buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index{
    self.expireLbl.text=expireDate;
}
-(void)selectedDateOfBirth:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    expireDate = [dateFormatter stringFromDate:datePicker.date];
}
-(void)datePicker
{
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.frame = CGRectMake(0.f, 0.f, datePicker.frame.size.width, 100.f);
    datePicker.datePickerMode=UIDatePickerModeDate;
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(selectedDateOfBirth:) forControlEvents:UIControlEventValueChanged];
    LGActionSheet *actionSheet=[[LGActionSheet alloc] initWithTitle:@"Choose any date, please"
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
-(void)Alert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:message
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
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}
-(void)getstureAnonmous{
    [self.mineButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.publicButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.friendsButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    isPublicLbl=NO;
    isMineLbl=NO;
    isFriendsLbl=NO;
    if(isAnonmousLbl==NO) {
        isAnonmousLbl=YES;
        StatusString=@"3";
        [self.anonymousButton setImage:[UIImage imageNamed:@"radioselect.png"] forState:UIControlStateNormal];
    }
    else {
        isAnonmousLbl=NO;
        StatusString=@"";
        [self.anonymousButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    }

}
-(void)gesturePublic{
    [self.anonymousButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.friendsButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.mineButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    isAnonmousLbl=NO;
    isMineLbl=NO;
    isFriendsLbl=NO;
    if(isPublicLbl==NO) {
        isPublicLbl=YES;
        StatusString=@"1";
        [self.publicButton setImage:[UIImage imageNamed:@"radioselect.png"] forState:UIControlStateNormal];
    }
    else {
        isPublicLbl=NO;
        StatusString=@"";
        [self.publicButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    }

}
-(void)gestureFriends{
    isPublicLbl=NO;
    isMineLbl=NO;
    isAnonmousLbl=NO;
    [self.anonymousButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.publicButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.mineButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    if(isFriendsLbl==NO) {
        isFriendsLbl=YES;
        StatusString=@"2";
        [self.friendsButton setImage:[UIImage imageNamed:@"radioselect.png"] forState:UIControlStateNormal];
    }
    else {
        isFriendsLbl=NO;
        StatusString=@"";
        [self.friendsButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    }

}
-(void)gestureMine{
    isPublicLbl=NO;
    isAnonmousLbl=NO;
    isFriendsLbl=NO;
    [self.anonymousButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.publicButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    [self.friendsButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
    if(isMineLbl==NO) {
        isMineLbl=YES;
        StatusString=@"4";
        [self.mineButton setImage:[UIImage imageNamed:@"radioselect.png"] forState:UIControlStateNormal];
    }
    else {
        isMineLbl=NO;
        StatusString=@"0";
        [self.mineButton setImage:[UIImage imageNamed:@"radiounselect.png"] forState:UIControlStateNormal];
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
-(void)showAlert:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:cancelAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)preLoad{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Print out the path to verify we are in the right place
        NSString *directory = [paths objectAtIndex:0];
        NSLog(@"Directory: %@", directory);
        
        // For each file in the directory, create full path and delete the file
        for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error])
        {
            
            if ([file isEqualToString:@"recordTest.mp4"]) {
                NSString *filePath = [directory stringByAppendingPathComponent:file];
                NSLog(@"File : %@", filePath);
                
                BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
                
                if (fileDeleted != YES || error != nil)
                {
                    // Deal with the error...
                }
                NSLog(@"File Dleted");
                
                
            }
            
        }
    }
}

-(void)showAlertPray:(NSString *)message view:(UIViewController *)controller{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    
    [alertController addAction:cancelAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [controller presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)stopRecord:(id)sender {
       [self.startRecordBtn setImage:[UIImage imageNamed:@"mike"] forState:UIControlStateNormal];
    [self stop];
  }
@end
