//
//  TimerScreen.h
//  GeneresPrayer
//
//  Created by Anbu on 17/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICircularSlider.h"
@interface TimerScreen : UIViewController@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *gradientView;
@property (strong, nonatomic) IBOutlet UIView *audioView;

@property (unsafe_unretained, nonatomic) IBOutlet UICircularSlider *circularSlider;

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *totalPrayCount;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
- (IBAction)previousAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *showTotalTimer;
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)playPause:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *subjectLble;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;
- (IBAction)valueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIButton *playGrrenButton;
- (IBAction)playGreen:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *peopleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
- (IBAction)share:(id)sender;
@property(nonatomic,strong)NSString *totalPrayTimer;
@property(nonatomic,strong)NSString *betweenPrayer;
@property(nonatomic,strong)NSMutableArray *datas;


@end
