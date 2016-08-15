//
//  DTLChecklist.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTLChecklist : NSObject <NSCoding>

/** 类别名称 */
@property(copy, nonatomic) NSString *name;
/** 事务模型 */
@property(strong, nonatomic) NSMutableArray *items;
/** 图片名称 */
@property(copy, nonatomic) NSString *iconName;

/** 计算没有勾选的事务 */
- (NSInteger)countUncheckedItems;

/** 对模型数组排序 */
- (void)sortChecklistItems;

@end
