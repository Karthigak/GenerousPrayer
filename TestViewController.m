//
//  TestViewController.m
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "TestViewController.h"
#import "SearchViewController.h"
#import "RequestViewController.h"
#import "ContactsViewController.h"
#import "FacebookViewController.h"
#import "TwitterViewController.h"
#import "MapViewController.h"
#import "CommonMethodClass.h"
#import "RequestFeedViewController.h"
#import "Constants.h"
#import "ActivityViewController.h"
@interface TestViewController ()<GUITabPagerDataSource, GUITabPagerDelegate>
{
    int i;
    UIView *statusBarView;
    int rotationSelectedIndex;
}
- (IBAction)barButtonBackPressed:(id)sender;
- (IBAction)back:(id)sender;
@property(nonatomic, strong) NSMutableArray * images;
@property(nonatomic, strong) NSMutableArray * titlesImage;
@property(nonatomic, strong) NSMutableArray * titleslbl;
@property(nonatomic, strong) NSMutableArray * selectedImages;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property(nonatomic,strong)NSMutableArray *text;

@property (weak, nonatomic) IBOutlet UIView *naviView;

@end

@implementation TestViewController
-(void)drawView{
    if (isiPad) {
        [self.naviView setFrame:CGRectMake(self.naviView.bounds.origin.x, self.naviView.bounds.origin.y,1024, self.naviView.bounds.size.height)];
    }else{
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
    [self drawView];
    rotationSelectedIndex=0;
    statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor  =  [UIColor whiteColor];
    [self.view addSubview:statusBarView];
    [self setDataSource:self];
    [self setDelegate:self];
    self.images = [[NSMutableArray alloc] init];
    self.titlesImage = [[NSMutableArray alloc] init];
    self.titleslbl = [[NSMutableArray alloc] init];
    self.selectedImages = [[NSMutableArray alloc] init];
    self.text = [NSMutableArray array];
    [self.text addObject:@"Search"];
    [self.text addObject:@"Requests"];
    [self.text addObject:@"Contacts"];
    [self.text addObject:@"Facebook"];
    [self.text addObject:@"Twitter"];
    [self.text addObject:@"Map"];
    [self.images addObject:@"searchicon.png"];
    [self.images addObject:@"adduser.png"];
    [self.images addObject:@"contactbook.png"];
    [self.images addObject:@"fb.png"];
    [self.images addObject:@"twitter.png"];
    [self.images addObject:@"map.png"];
    [ self.selectedImages addObject:@"searchiconactive.png"];
    [ self.selectedImages addObject:@"adduseractive.png"];
    [ self.selectedImages addObject:@"contactbookactive.png"];
    [ self.selectedImages addObject:@"fbactive.png"];
    [ self.selectedImages addObject:@"twitteractive.png"];
    [ self.selectedImages addObject:@"mapactive.png"];
    self.backBtn.hidden=YES;

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     if ([self.hideSkip isEqualToString:@"yes"]) {
        self.skipBtn.hidden=YES;
        self.backBtn.hidden=NO;
    }
    NSString *isTwitt=[[NSUserDefaults standardUserDefaults]valueForKey:@"TWITTER"];
    if ([isTwitt isEqualToString:@"isTwitter"]) {
        NSLog(@"cannot reload data");
    }else{
    [self reloadData];
    }
}

#pragma mark - Tab Pager Data Source

- (NSInteger)numberOfViewControllers {
    return 6;
}


- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    if (index==0) {
        SearchViewController*  vc;
 vc=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];

        return vc;

    }
    else if (index==1)
    {
        RequestViewController*  vc;
        vc=[self.storyboard instantiateViewControllerWithIdentifier:@"RequestViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];


        return vc;

    }
    
    else if (index==2)
    {
        ContactsViewController*  vc;
        vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactsViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];


        return vc;
        
    }
    else if (index==3)
    {
        FacebookViewController*  vc;
        vc=[self.storyboard instantiateViewControllerWithIdentifier:@"FacebookViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];


        return vc;
        
    }
    else if (index==4)
    {
        TwitterViewController*  vc;
        vc=[self.storyboard instantiateViewControllerWithIdentifier:@"TwitterViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];
        


        return vc;
        
    }
    else
    {
        MapViewController*  vc;
        vc=[self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                      green:arc4random_uniform(255) / 255.0f
                                                       blue:arc4random_uniform(255) / 255.0f alpha:1]];


        return vc;
        
    }

}

// Implement either viewForTabAtIndex: or titleForTabAtIndex:
- (UIView *)viewForTabAtIndex:(NSInteger)index {

    UIView *view=[[UIView alloc]init];
    UIImageView *img=[UIImageView new];
    UILabel *lblLine=[[UILabel alloc]init];
    UILabel *lbl=[[UILabel alloc]init];
    lbl.font=[UIFont fontWithName:@"Myriad Pro" size:15];
    img.tag=index;
    lbl.tag=index;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        view.frame=CGRectMake(20, 0, 170, self.tabHeight);
        lblLine.frame=CGRectMake(160, 0,0.5,self.tabHeight);
        img.frame=CGRectMake(70, 15, 22, 22);
        lbl.frame=CGRectMake(43, 40, 80, 22);
        if (index==0) {
            [self.titleslbl removeAllObjects];
            [self.titlesImage removeAllObjects];
        }

    }else{
        if (IS_IPHONE_5) {
            view.frame=CGRectMake(0, 0, 90, self.tabHeight);
            img.frame=CGRectMake(38, 15, 22, 22);
            lbl.frame=CGRectMake(8, 40, 80, 22);
            lblLine.frame=CGRectMake(92, 0,0.5,self.tabHeight);
        }
        else if (IS_IPHONE_6){
            view.frame=CGRectMake(0, 0, 98, self.tabHeight);
            img.frame=CGRectMake(37, 15, 22, 22);
            lblLine.frame=CGRectMake(98, 0,0.5,self.tabHeight);
            lbl.frame=CGRectMake(7, 40, 80, 22);

        }
        else if (IS_IPHONE_6_PLUS){
            view.frame=CGRectMake(0, 0, 98, self.tabHeight);
            img.frame=CGRectMake(37, 15, 22, 22);
            lblLine.frame=CGRectMake(98, 0,0.5,self.tabHeight);
            lbl.frame=CGRectMake(7, 40, 80, 22);

        }


    }
    if (index==rotationSelectedIndex){
        img.image=[UIImage imageNamed:[self.selectedImages objectAtIndex:0]];
        UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#A1CD46"];
        lbl.textColor=selectedFont;
    }
    else{
        img.image=[UIImage imageNamed:[self.images objectAtIndex:index]];
        UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#8fa8d6"];
        lbl.textColor=selectedFont;
    }
    [view addSubview:img];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.text=[NSString stringWithFormat:@"%@",[self.text objectAtIndex:index]];
    [view addSubview:lbl];
       if (index==5) {
        [lblLine setBackgroundColor:[UIColor clearColor]];
    }
    else{
        UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#193167"];
        [lblLine setBackgroundColor:backColor];
    }
    [view addSubview:lblLine];
    [self.titlesImage addObject:img];
    [self.titleslbl addObject:lbl];
   
    return view;
}

- (CGFloat)tabHeight {
    return 70.0f;
}

- (UIColor *)tabColor {
    return [UIColor clearColor];
}

- (UIColor *)tabBackgroundColor {
    UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"#2A50AB"];

    return backColor;
}

- (UIFont *)titleFont {
    // Default: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    return [UIFont fontWithName:@"Myriad Pro" size:17.0f];
}

- (UIColor *)titleColor {
    UIColor *col=[CommonMethodClass pxColorWithHexValue:@"8fa8d6"];
    return col;
}

#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Will transition from tab %ld to %ld", (long)[self selectedIndex], (long)index);
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Did transition to tab %ld", (long)index);
    if (index==4) {
        [[NSUserDefaults standardUserDefaults]setObject:@"isTwitter" forKey:@"TWITTER"];
    }else{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TWITTER"];
    }
    UIImageView *labels = self.titlesImage[index];
    UILabel *lbl = self.titleslbl[index];
    rotationSelectedIndex=(int)index;
    [self setImg:labels setLbl:lbl];
  
    
}

-(void)setImg:(UIImageView *)image setLbl:(UILabel *)lbl
{
    for (i=0; i<[self.titlesImage count]; i++) {
        UIImageView *temp=[ self.titlesImage objectAtIndex:i];
        UILabel *selecedLbl=[self.titleslbl objectAtIndex:i];
        if (image.tag==temp.tag) {
            image.image=[UIImage imageNamed:[self.selectedImages objectAtIndex:i]];
            UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#A1CD46"];
            lbl.textColor=selectedFont;
        }
        else
        {
            temp.image=[UIImage imageNamed:[self.images objectAtIndex:i]];
            UIColor *selectedFont=[CommonMethodClass pxColorWithHexValue:@"#8fa8d6"];
            selecedLbl.textColor=selectedFont;
        }
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width=CGRectGetWidth(self.view.bounds);
    [ statusBarView setFrame:CGRectMake(0, 0,width, 20)];
    NSLog(@"%lu",(unsigned long)self.titleslbl.count);
}
- (IBAction)barButtonBackPressed:(id)sender {
    
   ActivityViewController  *RFVC=[self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    [self.navigationController pushViewController:RFVC animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
