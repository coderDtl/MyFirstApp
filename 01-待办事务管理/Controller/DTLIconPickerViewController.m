//
//  DTLIconPickerViewController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/7.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLIconPickerViewController.h"

@interface DTLIconPickerViewController ()

@end

@implementation DTLIconPickerViewController
{
    NSArray *_icons;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _icons = @[@"No Icon", @"Appointments", @"Birthdays", @"Chores", @"Drinks", @"Folder", @"Groceries", @"Inbox", @"Photos", @"Trips"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem globalBackBarButtonItemWithTarget:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _icons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconPickerCell"];
    
    // 设置图片文字
    NSString *iconName = _icons[indexPath.row];
    cell.textLabel.text = iconName;
    cell.imageView.image = [UIImage imageNamed:iconName];
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *iconName = _icons[indexPath.row];
    
    // 通知代理
    [self.delegate iconPicker:self didPickIcon:iconName];
}

@end
