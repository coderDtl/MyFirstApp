//
//  DTLTextField.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLTextField.h"

@implementation DTLTextField

- (void)awakeFromNib
{
    [self setValue:DTLRGBColor(4, 169, 235) forKeyPath:@"_placeholderLabel.textColor"];
}

@end
