//
//  DTLChecklist.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLChecklist.h"
#import "DTLChecklistItem.h"

@implementation DTLChecklist

- (instancetype)init
{
    if (self = [super init]) {
        _items = [NSMutableArray array];
        self.iconName = @"No Icon";
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.items = [aDecoder decodeObjectForKey:@"items"];
        self.iconName = [aDecoder decodeObjectForKey:@"iconName"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.iconName forKey:@"iconName"];
}

- (NSInteger)countUncheckedItems
{
    NSInteger count = 0;
    for (DTLChecklistItem *item in _items) {
        if (!item.isChecked) { // 如果item没有勾选
            count += 1;
        }
    }
    
    return count;
}

/** 两个list名称比较排序 */
- (NSComparisonResult)compare:(DTLChecklist *)otherChecklist
{
    return [self.name localizedStandardCompare:otherChecklist.name];
}

- (void)sortChecklistItems
{
    [self.items sortUsingSelector:@selector(compare:)];
}

@end
