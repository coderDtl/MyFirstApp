//
//  UIView+DTLFrameExtension.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "UIView+DTLFrameExtension.h"

@implementation UIView (DTLFrameExtension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}

@end
