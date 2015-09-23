//
//  CustomAFNetworking.h
//  GeneresPrayer
//
//  Created by Sathish on 05/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface CustomAFNetworking : NSObject
+(NSMutableURLRequest *)postMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict;

+(NSMutableURLRequest *)getMethodWithUrl:(NSString *)url;
+(NSMutableURLRequest *)deleteMethodWithUrl:(NSString *)url;

@end
