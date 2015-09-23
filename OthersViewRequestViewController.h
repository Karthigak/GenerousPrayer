//
//  OthersViewRequestViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 27/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OthersViewRequestViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *datas;
@property(assign)int index;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UITextView *descView;
- (IBAction)valueChanged:(id)sender;

@property(nonatomic,strong)NSString *hidePreviousNextButton;
@property(strong,nonatomic)NSString *prayerId;
@property(strong,nonatomic)NSString *userId;

@end
