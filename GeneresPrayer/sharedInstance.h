//
//  sharedInstance.h
//  skinwatcher
//
//  Created by Sathish on 15/05/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface sharedInstance : NSObject
{
}

@property (nonatomic, retain) NSMutableArray *selectedStateImages;
@property (nonatomic, retain) NSMutableArray *selectedStateTitle;

+ (id)sharedManager;



@end
