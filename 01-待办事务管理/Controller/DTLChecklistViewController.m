//
//  DTLChecklistViewController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLChecklistViewController.h"
#import "DTLAddOrEditItemViewController.h"
#import "DTLChecklistItem.h"
#import "DTLChecklist.h"

static CGFloat const DTLChecklistRowHeight = 54;

@interface DTLChecklistViewController() <DTLAddOrEditItemViewControllerDelegate>

@end

@implementation DTLChecklistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem globalBackBarButtonItemWithTarget:self action:@selector(back)];
    
    self.title = self.checklist.name;
}

/** 左边按钮触发方法 */
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 
  * 设置cell的checkmark 
  */
- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(DTLChecklistItem *)item
{
    UILabel *checkmarkLabel = [cell viewWithTag:1001];
    
    if (item.isChecked) {
        checkmarkLabel.text = @"√";
    } else {
        checkmarkLabel.text = @"";
    }
}

/**
 * 设置cell的文字内容
 */
- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(DTLChecklistItem *)item
{
    // 取出cell的子控件label
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    
    label.text = item.text;
}

/**
 * 设置cell的日期内容
 */
- (void)configureDetailTextForCell:(UITableViewCell *)cell withChecklistItem:(DTLChecklistItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1002];
    // 由于cell的循环引用，要恢复字体颜色
    label.textColor = [UIColor grayColor];
    
    label.text = item.dueDateString;
    
    if ([label.text isEqualToString:@"准备处理的事务"]) {
        label.textColor = [UIColor redColor];
    } else if ([label.text isEqualToString:@"(可添加通知)"]) {
        label.textColor = DTLRGBColor(4, 168, 235);
    }
}

/** 在控制器跳转前会调用这个方法 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addItem"]) {
        
        // 拿到目标控制器设置代理
        UINavigationController *nav = segue.destinationViewController;
        DTLAddOrEditItemViewController *addItemVC = (DTLAddOrEditItemViewController *)nav.topViewController;
        // 设置代理
        addItemVC.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"editItem"]) {
        
        UINavigationController *nav = segue.destinationViewController;
        DTLAddOrEditItemViewController *editItemVC = (DTLAddOrEditItemViewController *)nav.topViewController;
        
        editItemVC.delegate = self;
        
        // 拿到行号
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        // 从模型数组取出模型
        DTLChecklistItem *itemToEdit = self.checklist.items[indexPath.row];
        // 传递模型到控制器
        editItemVC.itemToEdit = itemToEdit;
    }
}

#pragma mark - DTLAddOrEditItemViewControllerDelegate
- (void)addOrEditItemViewController:(DTLAddOrEditItemViewController *)controller didFinishAddingItem:(DTLChecklistItem *)item
{
    // 添加到数组
    [self.checklist.items addObject:item];
    
    // 对事务按截止时间排序
    [self.checklist sortChecklistItems];
    
    // 刷新表格
    NSInteger index = [self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addOrEditItemViewController:(DTLAddOrEditItemViewController *)controller didFinishEditingItem:(DTLChecklistItem *)item
{
    // 对事务按截止时间排序
    [self.checklist sortChecklistItems];
    
    // 刷新表格
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addOrEditItemViewControllerDidCancel:(DTLAddOrEditItemViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.checklist.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checklist"];
    
    // 取出对应行的数据模型
    DTLChecklistItem *item = self.checklist.items[indexPath.row];
    
    // 设置cell的显示内容
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [self configureDetailTextForCell:cell withChecklistItem:item];
    
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DTLChecklistRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 取出对应行的数据模型
    DTLChecklistItem *item = self.checklist.items[indexPath.row];
    
    // 模型切换勾选状态
    item.checked = !item.isChecked;
    
    // 设置cell的checkmark
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    // 取消或安排一个通知
    [item cancelOrResumeLocalNotification];
    
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数组中删除模型
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    // 刷新表格
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
