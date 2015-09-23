//
//  OnboardingPageviewController.h
//  GeneresPrayer
//
//  Created by Anbu on 15/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OnboardingViewController.h"
#import "FXPageControl.h"

@interface OnboardingPageviewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>{
    int value;

}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pages;
@property (nonatomic, strong) IBOutlet FXPageControl *pageControlDots;


@property(nonatomic,strong)NSString *checkString;
@end
