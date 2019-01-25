//
//  AppDelegate.m
//  Capp
//
//  Created by Mehdi Amine on 3/1/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthenticationViewController.h"
#import "CategoryTableViewController.h"
#import "ServiceManagerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize devToken = _devToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Register for Remote Notifications
    UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings
                                                            settingsForTypes:UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound
                                                            categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    AuthenticationViewController *authenticationViewController = [[AuthenticationViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = authenticationViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *trimmedDev = deviceToken.description;
    trimmedDev = [trimmedDev stringByReplacingOccurrencesOfString:@"<" withString:@""];
    trimmedDev = [trimmedDev stringByReplacingOccurrencesOfString:@">" withString:@""];
    trimmedDev = [trimmedDev stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _devToken = trimmedDev;
    
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", self.devToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
