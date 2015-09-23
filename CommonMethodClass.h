//
//  CommonMethodClass.h
//  Guruzillo
//
//  Created by Sathish on 27/05/15.
//  Copyright (c) 2015 Optisol Business Solution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonMethodClass : NSObject<UIAlertViewDelegate>
+(BOOL)isEmpty:(NSString *)str;
+(UIColor *)getColor:(NSInteger)index;
+(UIColor *)returnColor:(int)passedIndex;
+(NSString *)dateFormat:(NSString *)string;
+ (UIColor*)pxColorWithHexValue:(NSString*)hexValue
;


+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel otherButtonTitles:(NSString *)arrayOfButtons delegate:(id)dele;
+(BOOL) validateEmail: (NSString *) emailString;
+(CGSize)lblSize:(NSString *)content lblFont:(UIFont *)contectLblFont width:(int)Width;
+(void)showAlert:(NSString *)message view:(UIViewController *)controller;


+ (NSString *)relativeDateStringForDate:(NSString *)date;
+ (NSString*)base64forData:(NSData*)theData;
+(NSAttributedString *)PlaceHolderTextApperance:(NSString *)str color:(UIColor *)color;
+ (NSString *)age:(NSDate *)dateOfBirth;

@end
