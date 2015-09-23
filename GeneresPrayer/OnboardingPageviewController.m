//
//  OnboardingPageviewController.m
//  GeneresPrayer
//
//  Created by Anbu on 15/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "OnboardingPageviewController.h"
#import "Constants.h"
@interface OnboardingPageviewController ()

@end

@implementation OnboardingPageviewController
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)pageDots
{
    self.pageControlDots.numberOfPages = (NSInteger)self.pages.count;
    self.pageControlDots.defersCurrentPageDisplay = YES;
    self.pageControlDots.selectedDotShape = FXPageControlDotShapeCircle;
    self.pageControlDots.selectedDotSize = 17.0;
    self.pageControlDots.dotSize=17.0;
    self.pageControlDots.dotSpacing = 23.0;
    self.pageControlDots.wrapEnabled = YES;
    self.pageControlDots.dotImage=[UIImage imageNamed:@"dots.png"];
    self.pageControlDots.selectedDotImage=[UIImage imageNamed:@"greenselecteddot"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    value=0;
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pages = @[@"onboarding", @"onboardingII", @"onboardingIII"];

    [self pageDots];
    
    OnboardingViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    
    if(isiPad)
    {
        self.pageViewController.view.frame = CGRectMake(0,0, _pageViewController.view.frame.size.width, _pageViewController.view.frame.size.height);
    }
    else{
        self.pageViewController.view.frame = CGRectMake(0, _pageViewController.view.frame.origin.y, _pageViewController.view.frame.size.width, _pageViewController.view.frame.size.height);
 
    }
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor clearColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor clearColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor clearColor]];
    
}
- (OnboardingViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        
        return nil;
    }
  //  self.pageControlDots.currentPage = index;

    // Create a new view controller and pass suitable data.
    OnboardingViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.checkString=self.checkString;
    return pageContentViewController;
    
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnboardingViewController*) viewController).pageIndex;
    value=(int)index;
   self.pageControlDots.currentPage = value;
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((OnboardingViewController*) viewController).pageIndex;
    value=(int)index;
    self.pageControlDots.currentPage = value;

    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pages count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return value;
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

@end
