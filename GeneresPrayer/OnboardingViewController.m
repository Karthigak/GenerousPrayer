//
//  OnboardingViewController.m
//  GeneresPrayer
//
//  Created by Anbu on 15/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "OnboardingViewController.h"
#import "KLCPopup.h"
#import "CommonMethodClass.h"
#import "Constants.h"
#import "ViewController.h"
#import "OraganizationSignUpOne.h"
#import "IndividualSignUpOne.h"
@interface OnboardingViewController ()
{
    BOOL isClick;
}
@end

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    if (self.pageIndex==0) {
        if (IS_IPHONE_6) {
            self.imageTwo.image=[UIImage imageNamed:@"onboardingl6"];
        }else if(IS_IPHONE_4){
            self.imageTwo.image=[UIImage imageNamed:@"Fristonboardingfours"];
        }else if (IS_IPHONE_5){
       // self.imageTwo.image=[UIImage imageNamed:@"onboarding5s"];
        }else if (IS_IPHONE_6_PLUS){
            self.imageTwo.image=[UIImage imageNamed:@"onboarding16plus"];
        }
        self.getStartedButton.hidden=YES;
    }else if (self.pageIndex==1) {
        self.lblone.text=@"Create prayer lists for churches, projects, teams and organizations.";
        self.lbl.hidden=YES;
        self.linelbl.hidden=YES;
        self.getStartedButton.hidden=YES;
        if (IS_IPHONE_6) {
            self.imageTwo.image=[UIImage imageNamed:@"onboardingII6"];
            
        }else if(IS_IPHONE_4){
            self.imageTwo.image=[UIImage imageNamed:@"onboardingfours"];
            
        }else if (IS_IPHONE_5){
            self.imageTwo.image=[UIImage imageNamed:@"onboardingII5s"];
        }else if (IS_IPHONE_6_PLUS){
            self.imageTwo.image=[UIImage imageNamed:@"onboardingII6plus"];
        }
    }
    else if (self.pageIndex==2) {
        self.getStartedButton.hidden=NO;
        self.skipButton.hidden=YES;
        self.lblone.hidden=YES;
        self.linelbl.hidden=YES;
        NSString *temp=@"Grow your ability to pray more with a Prayer Timer that helps you focus on prayer, praying longer without running out of requests!";
        self.lbl.preferredMaxLayoutWidth = 300;
        [self.lbl setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.lbl setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.lbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.lbl.text=temp;
        if (IS_IPHONE_6) {
            self.imageTwo.image=[UIImage imageNamed:@"onboardingIII6"];
        }else if(IS_IPHONE_4){
            self.imageTwo.image=[UIImage imageNamed:@"Thirdonboardingfours"];
        }else if (IS_IPHONE_5){
            self.imageTwo.image=[UIImage imageNamed:@"onboardingIII5s"];
        }else if (IS_IPHONE_6_PLUS){
            self.imageTwo.image=[UIImage imageNamed:@"onboardingIII6plus"];
        }

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.lbl=nil;
    self.lblone=nil;
    self.skipButton=nil;
    self.getStartedButton=nil;
    self.imageTwo=nil;
    self.linelbl=nil;
    self.checkString=nil;
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}



- (IBAction)actionSkip:(id)sender
{
    if (isClick==NO) {

        if ([self.checkString isEqualToString:@"fromLogin"]) {
            [self getStarted:nil];
        }else{
            ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:obj animated:YES];
            
        }
    }
    
    
}
- (IBAction)getStarted:(id)sender {
    if (isClick==NO) {
        isClick=YES;
    if ([self.checkString isEqualToString:@"fromLogin"]) {
        UIView* contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 6.0;
        
        UILabel* HeaderLbl = [[UILabel alloc] init];
        HeaderLbl.translatesAutoresizingMaskIntoConstraints = NO;
        HeaderLbl.textColor = [UIColor blackColor];
        HeaderLbl.font = [UIFont boldSystemFontOfSize:17.0];
        HeaderLbl.text = @"Choose Account Type";
        HeaderLbl.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
        
        
        UIButton* organizationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        organizationButton.translatesAutoresizingMaskIntoConstraints = NO;
        organizationButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        UIColor *orgColor=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
        [organizationButton setTitleColor:orgColor forState:UIControlStateNormal];
        
        organizationButton.titleLabel.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
        [organizationButton setTitle:@"Oraganization" forState:UIControlStateNormal];
        organizationButton.layer.cornerRadius = 6.0;
        [organizationButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        organizationButton.tag=0;
        organizationButton.userInteractionEnabled=YES;
        organizationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIButton* individualButton = [UIButton buttonWithType:UIButtonTypeCustom];
        individualButton.translatesAutoresizingMaskIntoConstraints = NO;
        individualButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        [individualButton setTitleColor:orgColor forState:UIControlStateNormal];
        individualButton.userInteractionEnabled=YES;
        
        individualButton.titleLabel.font=[UIFont fontWithName:@"Myriad Pro-Bole" size:17];
        [individualButton setTitle:@"Individual" forState:UIControlStateNormal];
        individualButton.layer.cornerRadius = 6.0;
        [individualButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        individualButton.tag=1;
        individualButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        
        UILabel* lineLbl = [[UILabel alloc] init];
        lineLbl.translatesAutoresizingMaskIntoConstraints = NO;
        lineLbl.backgroundColor = [UIColor lightGrayColor];
        
        
        UILabel* separatorLbl = [[UILabel alloc] init];
        separatorLbl.translatesAutoresizingMaskIntoConstraints = NO;
        separatorLbl.backgroundColor = [UIColor lightGrayColor];
        
        
        [contentView addSubview:lineLbl];
        [contentView addSubview:separatorLbl];
        
        [contentView addSubview:HeaderLbl];
        [contentView addSubview:organizationButton];
        [contentView addSubview:individualButton];
        
        //constraints for popup view
        NSDictionary* views = NSDictionaryOfVariableBindings(contentView, HeaderLbl,organizationButton,individualButton,lineLbl,separatorLbl);
        NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(120)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        
        NSArray *constraint_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentView(250)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        
        [contentView addConstraints:constraint_H];
        [contentView addConstraints:constraint_W];
        
        //constraints for header label
        NSArray *HeaderLabel_W = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[HeaderLbl(180)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
        
        NSArray *HeaderLabel_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[HeaderLbl(40)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        [HeaderLbl addConstraints:HeaderLabel_H];
        [HeaderLbl addConstraints:HeaderLabel_W];
        //constraints for organization button
        NSArray *oraganizationButton_W= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[organizationButton(185)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views];
        
        NSArray *oraganizationButton_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[organizationButton(30)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views];
        [organizationButton addConstraints:oraganizationButton_H];
        [organizationButton addConstraints:oraganizationButton_W];
        
        //constraints for lineLbl
        
        NSArray *lineLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[lineLbl(185)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
        
        NSArray *lineLbl_W= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineLbl(0.3)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views];
        [lineLbl addConstraints:lineLbl_H];
        [lineLbl addConstraints:lineLbl_W];
        
        
        
        
        NSArray *SepratorlineLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[separatorLbl(0.3)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
        
        NSArray *SepratorlineLbl_W= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorLbl(70)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views];
        [separatorLbl addConstraints:SepratorlineLbl_H];
        [separatorLbl addConstraints:SepratorlineLbl_W];
        
        
        
        //constraints for organization button
        NSArray *individualButton_W= [NSLayoutConstraint constraintsWithVisualFormat:@"H:[individualButton(185)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
        
        NSArray *individualButton_H= [NSLayoutConstraint constraintsWithVisualFormat:@"V:[individualButton(30)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
        [individualButton addConstraints:individualButton_H];
        [individualButton addConstraints:individualButton_W];
        
        
        
        NSArray *lineLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70)-[lineLbl(0.3)]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
        NSArray *line_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[lineLbl]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
        
        [contentView addConstraints:lineLbl_V];
        [contentView addConstraints:line_H];
        
        
        NSArray *SeparaorlineLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(70)-[separatorLbl(50)]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views];
        NSArray *Separaorline_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(130)-[separatorLbl(0.3)]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
        
        [contentView addConstraints:Separaorline_H];
        [contentView addConstraints:SeparaorlineLbl_V];
        
        
        NSArray *headerLbl_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[HeaderLbl(40)]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
        
        NSArray *headerLbl_H= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[HeaderLbl]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views];
        
        
        
        NSArray *organization_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[organizationButton(30)]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
        NSArray *organization_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-10)-[organizationButton(185)]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views];
        
        NSArray *individual_V=  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(80)-[individualButton(30)]-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        NSArray *individual_H=  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(125)-[individualButton(185)]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views];
        [contentView addConstraints:headerLbl_V];
        [contentView addConstraints:headerLbl_H];
        [contentView addConstraints:organization_V];
        [contentView addConstraints:organization_H];
        
        [contentView addConstraints:individual_V];
        [contentView addConstraints:individual_H];
        
        
        
        // Show in popup
        KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,
                                                   (KLCPopupVerticalLayout)KLCPopupVerticalLayoutCenter);
        
        KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                                showType:KLCPopupShowTypeSlideInFromTop
                                             dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                maskType:KLCPopupMaskTypeClear
                                dismissOnBackgroundTouch:NO
                                   dismissOnContentTouch:NO];
        [popup showWithLayout:layout];
        
    }else{
        ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:obj animated:YES];
        
    }
    }
    // Generate content view to present
    
}
-(void)GoToRegistrationPage{
    
    
}
- (void)dismissButtonPressed:(id)sender {
    isClick=NO;
    if ([sender isKindOfClass:[UIView class]]) {
        [(UIView*)sender dismissPresentingPopup];
    }
    if ([self.checkString isEqualToString:@"fromLogin"]) {
        UIButton *button=(UIButton *)sender;
//            RegisterViewController *homeObj=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
//            if (button.tag==0) {
//                homeObj.registerString=@"Oraganization";
//                [self.navigationController pushViewController:homeObj animated:YES];
//        
//            }else{
//                homeObj.registerString=@"Individual";
//                [self.navigationController pushViewController:homeObj animated:YES];
//                
//            }
        OraganizationSignUpOne *org=[self.storyboard instantiateViewControllerWithIdentifier:@"OraganizationSignUpOne"];
        IndividualSignUpOne *Indvidual=[self.storyboard instantiateViewControllerWithIdentifier:@"IndividualSignUpOne"];

        if (button.tag==0) {
            //homeObj.registerString=@"Oraganization";
            [self.navigationController pushViewController:org animated:YES];
            
        }else{
            //homeObj.registerString=@"Individual";
            [self.navigationController pushViewController:Indvidual animated:YES];
            
        }
    }else{
        ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:obj animated:YES];
 
    }
  
    
   
}

@end
