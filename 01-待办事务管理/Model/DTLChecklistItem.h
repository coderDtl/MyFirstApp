//
//  DTLChecklistItem.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTLChecklistItem : NSObject <NSCoding>
/** 事务内容 */
@property(copy, nonatomic) NSString *text;
/** 保存一个事务是否被勾选 */
@property(assign, nonatomic, getter=isChecked) BOOL checked;
/** 截止日期 */
@property(copy, nonatomic) NSDate *dueDate;
/** 是否提醒用户 */
@property(assign, nonatomic) BOOL shouldRemind;
/** itemID */
@property(assign, nonatomic) NSInteger itemID;

/** 截止日期字符串 */
@property(copy, nonatomic) NSString *dueDateString;

/** 安排一个本地通知 */
- (void)scheduleNotification;

/** 取消或安排一个本地通知 */
- (void)cancelOrResumeLocalNotification;
@end
