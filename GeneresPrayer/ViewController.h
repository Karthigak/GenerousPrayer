//
//  ViewController.h
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    UITextField *activeField;
    
    CGPoint offset;
    CGFloat animatedDistance;
}
@property(nonatomic,strong)IBOutlet UIImageView *BgImageView;

@end

