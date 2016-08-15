//
//  DTLDataModel.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/6.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLDataModel.h"

@implementation DTLDataModel

static NSString * const indexOfDefaults = @"checklistIndex";
static NSString * const itemIDOfDefaults = @"checklistItemID";

- (instancetype)init
{
    if (self = [super init]) {
        [self loadChecklists];
//        NSLog(@"%@", [self documentPath]);
        // 初始化userDefaults的信息
        NSDictionary *dict = @{indexOfDefaults : @(-1), itemIDOfDefaults : @(0)};
        [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    }
    
    return  self;
}

- (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
- (NSString *)filePath
{
    return [[self documentPath] stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)saveChecklist
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:_lists forKey:@"checklists"];
    [archiver finishEncoding];
    
    [data writeToFile:[self filePath] atomically:YES];
}

/** 加载checklists */
- (void)loadChecklists
{
    NSString *filePath = [self filePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // 如果文件存在，就加载
        NSData *data = [NSMutableData dataWithContentsOfFile:[self filePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        _lists = [unarchiver decodeObjectForKey:@"checklists"];
        [unarchiver finishDecoding];
    } else { // 否则创建一个空数组
        _lists = [NSMutableArray array];
    }
}

- (void)setIndexOfSelectedChecklist:(NSInteger)index
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:indexOfDefaults];
}

- (NSInteger)indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:indexOfDefaults];
}

- (void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

+ (NSInteger)checklistItemID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemID = [userDefaults integerForKey:itemIDOfDefaults];
    // 下一个itemID
    [userDefaults setInteger:itemID + 1 forKey:itemIDOfDefaults];
    // 立刻写入，确保ID的唯一性
    [userDefaults synchronize];
    
    return itemID;
}

@end
