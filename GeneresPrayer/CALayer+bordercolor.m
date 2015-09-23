//
//  CALayer+bordercolor.m
//  demo1
//
//  Created by OBS_Macmini on 8/8/15.
//  Copyright (c) 2015 OptisolBusinessSolutions. All rights reserved.
//

#import "CALayer+bordercolor.h"

@implementation CALayer (bordercolor)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
