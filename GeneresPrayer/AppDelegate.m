//
//  AppDelegate.m
//  GeneresPrayer
//
//  Created by Sathish on 14/07/15.
//  Copyright (c) 2015 Optisol Business Solutions pvt ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonMethodClass.h"
#import "OnboardingPageviewController.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
@interface AppDelegate ()
{
    NSUserDefaults *defaults;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TWITTER"];

    
    if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
        
    }


    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TERMS"];
    defaults=[NSUserDefaults standardUserDefaults];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    OnboardingPageviewController *secondViewController = [storyBoard instantiateViewControllerWithIdentifier:@"OnboardingPageviewController"];
    ViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    NSString *onboardCheck=[defaults valueForKey:@"onboard"];
  
    if ([onboardCheck isEqualToString:@"onboardfirst"]) {
        UINavigationController* navigationController=[[UINavigationController alloc]initWithRootViewController:view];
        self.window.rootViewController = navigationController;
        
    }else{
        
        UINavigationController* navigationController=[[UINavigationController alloc]initWithRootViewController:secondViewController];
        [defaults setObject:@"onboardfirst" forKey:@"onboard"];

        self.window.rootViewController = navigationController;
           }
    
    [self.window makeKeyAndVisible];
    //[Fabric with:@[CrashlyticsKit]];
    [UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:devToken message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    //    [alert show];
    [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:@"deviceToken"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
@end
