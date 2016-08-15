//
//  UIBarButtonItem+DTLExtension.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/8.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "UIBarButtonItem+DTLExtension.h"

@implementation UIBarButtonItem (DTLExtension)

+ (instancetype)globalBackBarButtonItemWithTarget:(id)target action:(SEL)action
{
    // 自定义leftBarButtonItem
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(50, 44);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:DTLRGBColor(255, 60, 57) forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
