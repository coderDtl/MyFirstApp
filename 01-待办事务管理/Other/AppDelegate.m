//
//  AppDelegate.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "AppDelegate.h"
#import "DTLAllListsViewController.h"
#import "DTLNavigatonController.h"
#import "DTLDataModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    DTLDataModel *_dataModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建数据模型对象加载数据
    _dataModel = [[DTLDataModel alloc] init];
    DTLNavigatonController *nav = (DTLNavigatonController *)self.window.rootViewController;
    DTLAllListsViewController *allListsVC = nav.viewControllers[0];
    // 传递数据模型
    allListsVC.dataModel = _dataModel;
    
    // 发送本地通知
    /*
    UILocalNotification *local = [[UILocalNotification alloc] init];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    local.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    local.timeZone = [NSTimeZone defaultTimeZone];
    local.alertBody = @"2017年到了";
    local.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    */
     
    return YES;
}

/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收了一个通知 %@", notification);
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 保存数据
    [_dataModel saveChecklist];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // 保存数据
    [_dataModel saveChecklist];
}

@end
