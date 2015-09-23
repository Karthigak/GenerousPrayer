//
//  CommonMethodClass.m
//  Guruzillo
//
//  Created by Sathish on 27/05/15.
//  Copyright (c) 2015 Optisol Business Solution. All rights reserved.
//

#import "CommonMethodClass.h"
#import "UILabel+changeAppearance.h"
@implementation CommonMethodClass
+(NSString *)dateFormat:(NSString *)string
{
    NSString *dateString = string;
    NSArray *components = [dateString componentsSeparatedByString:@"T"];
    NSString *date = components[0];
    return date;
}

+(UIColor *)getColor:(NSInteger)index
{
    UIColor *color;
    if (index<10) {
        color=[CommonMethodClass returnColor:(int)index];
    }
    else
    {
        index=index%10;
        color=[CommonMethodClass returnColor:(int)index];
    }
    return color;
}
+(UIColor *)returnColor:(int)passedIndex
{
    UIColor *color;
    switch (passedIndex) {
        case 0:
            color=[UIColor colorWithRed:((float)(133)/255) green:((float)(59)/255) blue:((float)(225)/255) alpha:1.0];
            break;
        case 1:
            color=[UIColor colorWithRed:((float)(206)/255) green:((float)(72)/255) blue:((float)(61)/255) alpha:1.0];
            break;
        case 2:
            color=[UIColor colorWithRed:((float)(255)/255) green:((float)(76)/255) blue:((float)(136)/255) alpha:1.0];
            break;
        case 3:
            color=[UIColor colorWithRed:((float)(142)/255) green:((float)(176)/255) blue:((float)(33)/255) alpha:1.0];
            break;
        case 4:
            color=[UIColor colorWithRed:((float)(164)/255) green:((float)(99)/255) blue:((float)(165)/255) alpha:1.0];
            break;
        case 5:
            color=[UIColor colorWithRed:((float)(69)/255) green:((float)(138)/255) blue:((float)(242)/255) alpha:1.0];
            break;
        case 6:
            color=[UIColor colorWithRed:((float)(242)/255) green:((float)(104)/255) blue:((float)(57)/255) alpha:1.0];
            break;
        case 7:
            color=[UIColor colorWithRed:((float)(242)/255) green:((float)(200)/255) blue:((float)(104)/255) alpha:1.0];
            break;
        case 8:
            color=[UIColor colorWithRed:((float)(133)/255) green:((float)(59)/255) blue:((float)(225)/255) alpha:1.0];
            break;
        case 9:
            color=[UIColor colorWithRed:((float)(234)/255) green:((float)(76)/255) blue:((float)(136)/255) alpha:1.0];
            break;
        default:
            break;
    }
    return  color;
}

+ (UIColor*)pxColorWithHexValue:(NSString*)hexValue
{
    //Default
    UIColor *defaultResult = [UIColor blackColor];
    
    //Strip prefixed # hash
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    
    //Determine if 3 or 6 digits
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3)
    {
        componentLength = 1;
    }
    else if ([hexValue length] == 6)
    {
        componentLength = 2;
    }
    else
    {
        return defaultResult;
    }
    
    BOOL isValid = YES;
    CGFloat components[3];
    
    //Seperate the R,G,B values
    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 256.0f;
    }
    
    if (!isValid) {
        return defaultResult;
    }
    
    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}

+(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]||[str  isEqualToString:NULL]||[str isEqualToString:@"(null)"]||str==nil || [str isEqualToString:@"<null>"]|| [str isEqual:[NSNull null]]){
        return YES;
    }
    return NO;
}

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel otherButtonTitles:(NSString *)arrayOfButtons delegate:(id)dele{
    
    UIAlertView *alert=[[UIAlertView alloc]init];
    if ([message isKindOfClass:[NSNull class]]||[self isEmpty:message]) {
        alert.message=nil;
    }
    else{
        alert.message=message;

    }
    if ([title isKindOfClass:[NSNull class]]||[self isEmpty:title]) {
        alert.title=nil;
    }
    else{
        alert.title=title;
        
    }
    if ([cancel isKindOfClass:[NSNull class]]||[self isEmpty:cancel]) {
        [alert addButtonWithTitle:nil];

    }
    else{
        
        [alert addButtonWithTitle:cancel];
        
    }
    if ([arrayOfButtons isKindOfClass:[NSNull class]]||[self isEmpty:arrayOfButtons]) {
        [alert addButtonWithTitle:nil];

    }
    else{

        [alert addButtonWithTitle:arrayOfButtons];

    }
    alert.delegate=dele;
    [alert show];
    
}

+(BOOL) validateEmail: (NSString *) emailString {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}
+(CGSize)lblSize:(NSString *)content lblFont:(UIFont *)contectLblFont width:(int)Width
{
    CGSize maximumLabelSize;
    maximumLabelSize = CGSizeMake(Width,9999);
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:content
     attributes:@
     {
     NSFontAttributeName:contectLblFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){maximumLabelSize.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    return size;
}
+(void)showAlert:(NSString *)message view:(UIViewController *)controller{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    [alertController addAction:cancelAction];
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[CommonMethodClass pxColorWithHexValue:@"A3CC39"]];
    UILabel * appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [controller presentViewController:alertController animated:YES completion:nil];
    
}
+ (NSString *)relativeDateStringForDate:(NSString *)date
{
    NSString *temp;
    
    NSString* format = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Set up an NSDateFormatter for UTC time zone
    NSDateFormatter* formatterUtc = [[NSDateFormatter alloc] init];
    [formatterUtc setDateFormat:format];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:date];
    // Set up an NSDateFormatter for the device's local time zone
    NSDateFormatter* formatterLocal = [[NSDateFormatter alloc] init];
    [formatterLocal setDateFormat:format];
    [formatterLocal setTimeZone:[NSTimeZone localTimeZone]];
    // Create local NSDate with time zone difference
    NSDate* localDate = [formatterUtc dateFromString:[formatterLocal stringFromDate:utcDate]];
    //calender settings
    NSCalendarUnit units = NSDayCalendarUnit | NSWeekOfYearCalendarUnit |
    NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    //local dates
    NSDate* datetime = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:format];
    NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter stringFromDate:datetime];
    NSDate* sysUTCDate = [dateFormatter dateFromString:dateTimeInIsoFormatForZuluTimeZone];

    
    NSDateFormatter* formatterLocalFromUtc = [[NSDateFormatter alloc] init];
    [formatterLocalFromUtc setDateFormat:format];
    [formatterLocalFromUtc setTimeZone:[NSTimeZone localTimeZone]];
    // Create local NSDate with time zone difference
    NSDate* curreentDate = [formatterUtc dateFromString:[formatterLocalFromUtc stringFromDate:sysUTCDate]];
    
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:curreentDate];
    NSDate *today = [cal dateFromComponents:components1];
    
    //server date
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:localDate];
    NSDate *thatdate = [cal dateFromComponents:components1];
    
    
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                    options:0];
    

    
    if (components.year > 0) {
        temp=[NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        temp= [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        temp= [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            temp= [NSString stringWithFormat:@"%ld day ago", (long)components.day];
        } else {
            temp=[NSString stringWithFormat:@"%ld day ago", (long)components.day];
        }
    } else {
        if (components.hour!=0) {
            if(components.hour==1)
            {
                temp= [NSString stringWithFormat:@"%ld hour ago",(long)components.hour];
            }
            else
            {
                temp= [NSString stringWithFormat:@"%ld hours ago",(long)components.hour];
            }
            
        } else if (components.minute!=0){
            if(components.minute==1)
            {
                temp= [NSString stringWithFormat:@"%ld min ago",(long)components.minute];
            }
            else
            {
                temp=[NSString stringWithFormat:@"%ld mins ago",(long)components.minute];
            }
            
        }
        else if (components.second!=0){
            if(components.second==1)
            {
                temp= [NSString stringWithFormat:@"%ld sec ago",(long)components.second];
            }
            else
            {
                temp=[NSString stringWithFormat:@"%ld secs ago",(long)components.second+2];
            }
            
        }
    }
    return temp;
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
+(NSAttributedString *)PlaceHolderTextApperance:(NSString *)str color:(UIColor *)color{
    
    
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
                                                        NSFontAttributeName : [UIFont fontWithName:@"Myriad Pro" size:17.0]
                                                        }];
}
+ (NSString *)age:(NSDate *)dateOfBirth {
    NSInteger years;
    NSInteger months;
    NSInteger days = 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        years = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        years = [dateComponentsNow year] - [dateComponentsBirth year];
    }
    
    if ([dateComponentsNow year] == [dateComponentsBirth year]) {
        months = [dateComponentsNow month] - [dateComponentsBirth month];
    } else if ([dateComponentsNow year] > [dateComponentsBirth year] && [dateComponentsNow month] > [dateComponentsBirth month]) {
        months = [dateComponentsNow month] - [dateComponentsBirth month];
    } else if ([dateComponentsNow year] > [dateComponentsBirth year] && [dateComponentsNow month] < [dateComponentsBirth month]) {
        months = [dateComponentsNow month] - [dateComponentsBirth month] + 12;
    } else {
        months = [dateComponentsNow month] - [dateComponentsBirth month];
    }
    
    if ([dateComponentsNow year] == [dateComponentsBirth year] && [dateComponentsNow month] == [dateComponentsBirth month]) {
        days = [dateComponentsNow day] - [dateComponentsBirth day];
    }
    
    if (years == 0 && months == 0) {
        if (days == 1) {
            return [NSString stringWithFormat:@"%ld day", (long)days];
        } else {
            return [NSString stringWithFormat:@"%ld days", (long)days];
        }
    } else if (years == 0) {
        if (months == 1) {
            return [NSString stringWithFormat:@"%ld month", (long)months];
        } else {
            return [NSString stringWithFormat:@"%ld months", (long)months];
        }
    } else if ((years != 0) && (months == 0)) {
        if (years == 1) {
            return [NSString stringWithFormat:@"%ld year", (long)years];
        } else {
            return [NSString stringWithFormat:@"%ld years", (long)years];
        }
    } else {
        if ((years == 1) && (months == 1)) {
            return [NSString stringWithFormat:@"%ld year and %ld month", (long)years, (long)months];
        } else if (years == 1) {
            return [NSString stringWithFormat:@"%ld year and %ld months", (long)years, (long)months];
        } else if (months == 1) {
            return [NSString stringWithFormat:@"%ld years and %ld month", (long)years, (long)months];
        } else {
            return [NSString stringWithFormat:@"%ld years and %ld months", (long)years, (long)months];
        }
    }
}

@end
