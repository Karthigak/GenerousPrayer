//
//  CustomAFNetworking.m
//  GeneresPrayer
//
//  Created by Sathish on 05/08/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "CustomAFNetworking.h"

@implementation CustomAFNetworking
+(NSMutableURLRequest *)postMethodWithUrl:(NSString *)url dictornay:(NSDictionary *)dict{

    
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSLog(@"Proper JSON Object");
       
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];

    return request;
}
+(NSMutableURLRequest *)getMethodWithUrl:(NSString *)url{
    NSURL *URL= [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    return  request;
}
+(NSMutableURLRequest *)deleteMethodWithUrl:(NSString *)url{
    NSURL *URL= [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    return  request;
}
@end
