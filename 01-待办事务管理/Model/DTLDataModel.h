//
//  DTLDataModel.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/6.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTLDataModel : NSObject

/** 模型数组 */
@property(strong, nonatomic) NSMutableArray *lists;

/** 保存checklist */
- (void)saveChecklist;

/** 设置checklistIndex */
- (void)setIndexOfSelectedChecklist:(NSInteger)index;

/** 返回checklistIndex */
- (NSInteger)indexOfSelectedChecklist;

/** 对模型数组排序 */
- (void)sortChecklists;

/** 为item设置一个ID */
+ (NSInteger)checklistItemID;

@end
