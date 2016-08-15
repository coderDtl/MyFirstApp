//
//  DTLChecklistItem.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLChecklistItem.h"
#import "DTLDataModel.h"

@implementation DTLChecklistItem

- (instancetype)init
{
    if (self = [super init]) {
        // 为每一个item设置一个ID
        self.itemID = [DTLDataModel checklistItemID];
    }
    
    return self;
}

- (void)dealloc
{
    // 对象销毁时取消通知
    UILocalNotification *currentNotification = [self notificationForItem];
    if (currentNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:currentNotification];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeBool:self.isChecked forKey:@"isChecked"];
    [aCoder encodeObject:self.dueDate forKey:@"dueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"shouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.checked = [aDecoder decodeBoolForKey:@"isChecked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"dueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"shouldRemind"];
        self.itemID = [aDecoder decodeIntegerForKey:@"itemID"];
    }
    
    return self;
}

#pragma mark - 本地通知处理
/** 获取item对应的通知(通过itemID) */
- (UILocalNotification *)notificationForItem
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notifications) {
        NSInteger itemID = [notification.userInfo[@"itemID"] integerValue];
        if (itemID && itemID == self.itemID) {
            return notification;
        }
    }
    
    return nil;
}

- (void)scheduleNotification
{
    // iOS8以后，要推送通知，都要获取用户的权限(需要用户同意)才可以推送
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 先取消旧的通知
    UILocalNotification *currentNotification = [self notificationForItem];
    if (currentNotification) {
//        NSLog(@"取消旧的通知");
        [[UIApplication sharedApplication] cancelLocalNotification:currentNotification];
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        localNotification.userInfo = @{@"itemID" : @(self.itemID)};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//        NSLog(@"发出一个通知");
    }
}

- (void)cancelOrResumeLocalNotification
{
    if (self.isChecked) { // 如果打勾
        UILocalNotification *currentNotification = [self notificationForItem];
        if (currentNotification) {
//            NSLog(@"用户打勾，取消通知");
            [[UIApplication sharedApplication] cancelLocalNotification:currentNotification];
        }
    } else { // 用户取消打勾
        [self scheduleNotification];
    }
}

#pragma mark - 日期时间处理
- (NSComparisonResult)compare:(DTLChecklistItem *)checklistItem
{
    return [self.dueDate compare:checklistItem.dueDate];
}

- (NSString *)dueDateString
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *dueDate = [fmt dateFromString:[fmt stringFromDate:self.dueDate]];
    
    if (self.shouldRemind) { // 打开开关
        if ([dueDate compare:[NSDate date]] != NSOrderedAscending) {
            NSDateComponents *cmps = [dueDate deltaFrom:[NSDate date]];
            if ([dueDate isToday]) { // 今天
                if (cmps.hour >= 1 || cmps.minute >= 30) { // 半小时以上
                    return [NSString stringWithFormat:@"%zd小时%zd分钟之后通知", cmps.hour, cmps.minute];
                } else { // 小于半小时
                    return @"准备处理的事务";
                }
            } else if ([dueDate isTomorrow]) { // 明天
                fmt.dateFormat = @"明天 HH:mm";
                return [fmt stringFromDate:dueDate];
            } else { // 未来
                fmt.dateStyle = NSDateFormatterMediumStyle;
                fmt.timeStyle = NSDateFormatterShortStyle;
                return [fmt stringFromDate:self.dueDate];;
            }
        } else { // 过期
            return @"通知已过期！";
        }
    } else { // 关闭开关
        return @"(可添加通知)";
    }
}

@end
