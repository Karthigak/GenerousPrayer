//
//  OnboardingViewController.h
//  GeneresPrayer
//
//  Created by Anbu on 15/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingViewController : UIViewController

- (IBAction)actionSkip:(id)sender;
- (IBAction)getStarted:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageTwo;
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *lblone;
@property (weak, nonatomic) IBOutlet UILabel *linelbl;
@property (weak, nonatomic) NSString *checkString;

@end
