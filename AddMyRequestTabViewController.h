//
//  AddMyRequestTabViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "NIDropDown.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
@interface AddMyRequestTabViewController : UIViewController<NIDropDownDelegate,UIScrollViewDelegate>
{
    HMSegmentedControl *headerBar ;
    HMSegmentedControl *tabBar ;

    CGFloat viewWidth;
    CGFloat viewHeight;
    
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    NSUserDefaults *defaults;

}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)showDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *expireButton;
@property (weak, nonatomic) IBOutlet UITextField *subjectTxt;
- (IBAction)showCategoryList:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;

@property (weak, nonatomic) IBOutlet UILabel *expireLbl;

@property (weak, nonatomic) IBOutlet UIButton *urgentButton;
- (IBAction)urgentAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgrss;

@property (weak, nonatomic) IBOutlet UIView *audioContainerView;
@property (weak, nonatomic) IBOutlet UILabel *showTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *startRecordBtn;
- (IBAction)playAudio:(id)sender;
- (IBAction)startRecord:(id)sender;
- (IBAction)deleteAudion:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteAudioBtn;
@property (weak, nonatomic) IBOutlet UIButton *tapButton;

@property (weak, nonatomic) IBOutlet UIButton *canelBtn;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)addRequest:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;




@property (weak, nonatomic) IBOutlet UIButton *anonymousButton;
@property (weak, nonatomic) IBOutlet UIButton *publicButton;
@property (weak, nonatomic) IBOutlet UIButton *mineButton;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;

- (IBAction)anonymousAction:(id)sender;



@end
