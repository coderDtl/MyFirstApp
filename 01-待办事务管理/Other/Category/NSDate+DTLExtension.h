//
//  NSDate+DTLExtension.h
//  01.百思不得姐-基本配置
//
//  Created by datianlao on 16/6/16.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DTLExtension)

/** 比较self和from的时间差值 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
/** 是否是昨天 */
- (BOOL)isYesterday;
/** 是否是今天 */
- (BOOL)isToday;
/** 是否是今年 */
- (BOOL)isThisYear;
/** 是否是明天 */
- (BOOL)isTomorrow;
/** 日期转字符串 */
- (NSString *)dateToString;
@end
