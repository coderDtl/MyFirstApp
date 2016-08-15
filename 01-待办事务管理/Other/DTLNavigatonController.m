//
//  DTLNavigatonController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLNavigatonController.h"

@implementation DTLNavigatonController

// 第一次使用这个类时调用
+ (void)initialize
{
    // 修改导航栏按钮默认样式
    NSDictionary *attrsNormal = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:15],
                            NSForegroundColorAttributeName : [UIColor blackColor]
                            };
    NSDictionary *attrsEnabled = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:15],
                            NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                   };
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:attrsNormal forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrsEnabled forState:UIControlStateDisabled];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 恢复滑动移除控制器的功能
    self.interactivePopGestureRecognizer.delegate = nil;
}

@end
