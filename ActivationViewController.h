//
//  ActivationViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 16/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationViewController : UIViewController
{
    
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
    
}
@property(nonatomic,strong)NSString *activationCode;
@end
