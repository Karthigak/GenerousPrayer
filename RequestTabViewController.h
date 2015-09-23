//
//  RequestTabViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 25/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "LGActionSheet.h"
#import "MBProgressHUD.h"
#import "DXPopover.h"
@interface RequestTabViewController : UIViewController<LGActionSheetDelegate>
{
    HMSegmentedControl *headerBar ;
    HMSegmentedControl *tabBar ;
    
    CGFloat viewWidth;
    CGFloat viewHeight;
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    BOOL isCancel;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXPopover *popover;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
- (IBAction)getEmailFromLocal:(id)sender;
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

@end
