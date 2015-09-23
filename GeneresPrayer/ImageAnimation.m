//
//  ImageAnimation.m
//  GeneresPrayer
//
//  Created by Macbook Pro  on 8/18/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "ImageAnimation.h"
@implementation ImageAnimation
+(NSArray * )animatedImage:(NSArray *)arrayOfimages
{
    NSMutableArray *arrauy=[NSMutableArray array];
    for (int i=0; i<[arrayOfimages count]; i++) {
        
        NSURL *url = [NSURL URLWithString:[arrayOfimages objectAtIndex:i]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        [arrauy addObject:img];
    }
    
    return arrauy;
}

@end
