//
//  SWUtilityButtonView.m
//  SWTableViewCell
//
//  Created by Matt Bowman on 11/27/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "SWUtilityButtonView.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "CommonMethodClass.h"
#import "Constants.h"
@interface SWUtilityButtonView()
{
    UILabel *lbl;
    CGFloat buttonWidth;
}
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSMutableArray *buttonBackgroundColors;

@end

@implementation SWUtilityButtonView

#pragma mark - SWUtilityButonView initializers



- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    self = [self initWithFrame:CGRectZero utilityButtons:utilityButtons parentCell:parentCell utilityButtonSelector:utilityButtonSelector];
   
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    self = [super initWithFrame:frame];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:0.0]; // constant will be adjusted dynamically in -setUtilityButtons:.
        self.widthConstraint.priority = UILayoutPriorityDefaultHigh;
        [self addConstraint:self.widthConstraint];
        
        _parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
        self.utilityButtons = utilityButtons;
        //UIColor *backColor=[CommonMethodClass pxColorWithHexValue:@"A3CC39"];
            if(isiPad){

             self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"swipebgIpad.png"]];
        }else{
            if(IS_IPHONE_5)
            {
                
                self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"swipebg.png"]];
            }
            else if (IS_IPHONE_6_PLUS)
            {
                self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"swipebg@2x.png"]];
                
            }
            else if (IS_IPHONE_6)
            {
                self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"swipebg@2x.png"]];
                
            }

        }
       
        self.text=[[NSArray alloc]init];
        self.iPadPosition=[[NSArray alloc]init];

        
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (void)setUtilityButtons:(NSArray *)utilityButtons
{
    // if no width specified, use the default width
    [self setUtilityButtons:utilityButtons WithButtonWidth:kUtilityButtonWidthDefault];
}
-(void)lblToSet:(UILabel *)lbl atPlace:(CGFloat )value atIndex:(int)index
{
    if(IS_IPHONE_6_PLUS){
        [lbl setFrame:CGRectMake(value+(index*76), 80, 75, 25)];
    }else{
        [lbl setFrame:CGRectMake(value+(index*76), 70, 75, 25)];
}
}
-(void)lblToSetOne:(UILabel *)lbl atPlace:(CGFloat )value atIndex:(int)index
{
    if(IS_IPHONE_6_PLUS){
        [lbl setFrame:CGRectMake(value+(index*116), 75, 115, 25)];

    }else{
    [lbl setFrame:CGRectMake(value+(index*116), 70, 115, 25)];
    }
}

-(void)lblToSetOneIpad:(UILabel *)lbl atPlace:(CGFloat )value atIndex:(int)index
{
    [lbl setFrame:CGRectMake(value+(index*56), 85, 55, 25)];

}
-(void )setLble:(NSInteger )toCreate text:(NSArray *)aValue
{
   
    for (int i=0; i<=(int)toCreate-1; i++) {
        lbl=[[UILabel alloc]init];
        [lbl setText:[aValue objectAtIndex:i]];
        if ([aValue count]==3 && [self.iPadPosition count]==3) {
            NSNumber *temp=[self.iPadPosition objectAtIndex:i];
            CGFloat postionToSet=[temp floatValue];
            if (isiPad) {
                if (i==1) {
                    [self lblToSetOne:lbl atPlace:postionToSet atIndex:i];
                }else if (i==0){
                    [self lblToSetOne:lbl atPlace:postionToSet atIndex:i];
                }else{
                    [self lblToSetOne:lbl atPlace:postionToSet atIndex:i];
                }
            }else{
                if(IS_IPHONE_5)
                {
                    if (i==1) {
                        [self lblToSetOne:lbl atPlace:-10 atIndex:i];
                        
                    }else if (i==0){
                        [self lblToSetOne:lbl atPlace:-2 atIndex:i];
                    }else{
                        [self lblToSetOne:lbl atPlace:-17 atIndex:i];
                    }
                }else if (IS_IPHONE_6)
                {
                    if (i==1) {
                        [self lblToSetOne:lbl atPlace:17 atIndex:i];
                    }else if (i==0){
                        [self lblToSetOne:lbl atPlace:7 atIndex:i];
                    }else{
                        [self lblToSetOne:lbl atPlace:28 atIndex:i];
                    }

                }else if(IS_IPHONE_6_PLUS){
                    if (i==1) {
                        [self lblToSetOne:lbl atPlace:40 atIndex:i];
                    }else if (i==0){
                        [self lblToSetOne:lbl atPlace:15 atIndex:i];
                    }else{
                        [self lblToSetOne:lbl atPlace:65 atIndex:i];
                    }
                }
            }
            
            lbl.textAlignment=NSTextAlignmentCenter;
         }
        else
        {
            NSNumber *temp=[self.iPadPosition objectAtIndex:i];
            CGFloat postionToSet=[temp floatValue];
            if (isiPad) {
                [self lblToSetOneIpad:lbl atPlace:postionToSet atIndex:i];
//                if (i==0) {
//                    [lbl setFrame:CGRectMake(60+(i*56), 85, 55, 25)];
//                }else if (i==1){
//                    [lbl setFrame:CGRectMake(170+(i*56), 85, 55, 25)];
//                }else if (i==2){
//                    [lbl setFrame:CGRectMake(275+(i*56), 85, 55, 25)];
//                }else if (i==3){
//                    [lbl setFrame:CGRectMake(377+(i*56), 85, 55, 25)];
//                }else if (i==4){
//                    [lbl setFrame:CGRectMake(475+(i*56), 85, 55, 25)];
//                }
                
            }else{
                if(IS_IPHONE_5){
                    if (i==0) {
                        [self lblToSetOneIPhone:lbl atPlace:postionToSet atIndex:i];
                        //[lbl setFrame:CGRectMake(15+(i*56), 85, 55, 25)];
                    }else if (i==1){
                        [self lblToSetOneIPhone:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(28+(i*56), 85, 55, 25)];
                    }else if (i==2){
                        [self lblToSetOneIPhone:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(38+(i*56), 85, 55, 25)];
                    }else if (i==3){
                        [self lblToSetOneIPhone:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(43+(i*56), 85, 55, 25)];
                    }else if (i==4){
                        [self lblToSetOneIPhone:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(48+(i*56), 85, 55, 25)];
                    }
                }
                else if (IS_IPHONE_6){
                    if (i==0 || i==4) {
                        [self lblToSetOneIPhone6:lbl atPlace:postionToSet atIndex:i];
                        //[lbl setFrame:CGRectMake(18+(i*76), 85, 75, 25)];
                    }else if(i==3) {
                        [self lblToSetOneIPhone6:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(20+(i*76), 85, 75, 25)];
                    }else if(i==1) {
                        [self lblToSetOneIPhone6:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(24+(i*76), 85, 75, 25)];
                    }else {
                        [self lblToSetOneIPhone6:lbl atPlace:postionToSet atIndex:i];
//                        [lbl setFrame:CGRectMake(25+(i*76), 85, 75, 25)];
                    }
                }
                else if(IS_IPHONE_6_PLUS){
                    if (i==0) {
                        [self lblToSet:lbl atPlace:postionToSet atIndex:i];
                        //[self lblToSet:lbl atPlace:25 atIndex:i];
                    }else if (i==1){
                        [self lblToSet:lbl atPlace:postionToSet atIndex:i];
//                        [self lblToSet:lbl atPlace:38 atIndex:i];
                    }else if (i==2){
                        [self lblToSet:lbl atPlace:postionToSet atIndex:i];
//                        [self lblToSet:lbl atPlace:48 atIndex:i];
                    }else if (i==3){
                        [self lblToSet:lbl atPlace:postionToSet atIndex:i];
//                        [self lblToSet:lbl atPlace:55 atIndex:i];
                    }else if (i==4){
                        [self lblToSet:lbl atPlace:postionToSet atIndex:i];
//                        [self lblToSet:lbl atPlace:60 atIndex:i];
                    }
                }
            }
           
            lbl.textAlignment=NSTextAlignmentLeft;
           

        }
        lbl.textColor=[UIColor whiteColor];
        lbl.font=[UIFont fontWithName:@"Myriad Pro" size:15];
        [self addSubview:lbl];
    }
}
-(void)lblToSetOneIPhone:(UILabel *)lbl atPlace:(CGFloat )value atIndex:(int)index{
   [lbl setFrame:CGRectMake(value+(index*56), 85, 55, 25)];
}
-(void)lblToSetOneIPhone6:(UILabel *)lbl atPlace:(CGFloat )value atIndex:(int)index{
    [lbl setFrame:CGRectMake(value+(index*76), 85, 75, 25)];

}

-(void)setLableText:(NSArray *)aValues iPadPosition:(NSArray *)pos

{
    self.text=[NSArray arrayWithArray:aValues];
    self.iPadPosition=[NSArray arrayWithArray:pos];
}
-(void)setOrientation:(NSString *)orientation{
    self.OrientationCheck=orientation;
}
- (void)setUtilityButtons:(NSArray *)utilityButtons WithButtonWidth:(CGFloat)width
{
    buttonWidth=width;
    for (UIButton *button in _utilityButtons)
    {
        [button removeFromSuperview];
        
    }
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    _utilityButtons = [utilityButtons copy];
    
    if (utilityButtons.count)
    {
        NSUInteger utilityButtonsCounter = 0;
        UIView *precedingView = nil;
        
        for (UIButton *button in _utilityButtons)
        {

            [self setLble:(NSInteger)utilityButtons.count text:self.text];
            
            [self addSubview:button];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            if (!precedingView)
            {
                // First button; pin it to the left edge.
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]"
                                                                             options:0L
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(button)]];
            }
            else
            {
                // Subsequent button; pin it to the right edge of the preceding one, with equal width.
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[precedingView][button(==precedingView)]"
                                                                             options:0L
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(precedingView, button)]];
            }
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                                         options:0L
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(button)]];
            
            
            SWUtilityButtonTapGestureRecognizer *utilityButtonTapGestureRecognizer = [[SWUtilityButtonTapGestureRecognizer alloc] initWithTarget:_parentCell action:_utilityButtonSelector];
            utilityButtonTapGestureRecognizer.buttonIndex = utilityButtonsCounter;
            [button addGestureRecognizer:utilityButtonTapGestureRecognizer];
            
            utilityButtonsCounter++;
            precedingView = button;
            
        }
        
        // Pin the last button to the right edge.
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[precedingView]|"
                                                                     options:0L
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(precedingView)]];
    }
    
//    self.widthConstraint.constant = (buttonWidth * utilityButtons.count);

    self.widthConstraint.constant = (width * utilityButtons.count);
    
    [self setNeedsLayout];
    
    return;
}

#pragma mark -

- (void)pushBackgroundColors
{
    self.buttonBackgroundColors = [[NSMutableArray alloc] init];
    
    for (UIButton *button in self.utilityButtons)
    {
        [self.buttonBackgroundColors addObject:button.backgroundColor];
    }
}

- (void)popBackgroundColors
{
    NSEnumerator *e = self.utilityButtons.objectEnumerator;
    
    for (UIColor *color in self.buttonBackgroundColors)
    {
        UIButton *button = [e nextObject];
        button.backgroundColor = color;
    }
    
    self.buttonBackgroundColors = nil;
}

@end

