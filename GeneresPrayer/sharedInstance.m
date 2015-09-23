//
//  sharedInstance.m
//  skinwatcher
//
//  Created by Sathish on 15/05/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "sharedInstance.h"

@implementation sharedInstance
@synthesize selectedStateImages,selectedStateTitle;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static sharedInstance *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
       selectedStateImages =[[NSMutableArray alloc]init];
        selectedStateTitle =[[NSMutableArray alloc]init];

    }
    return self;
}
@end