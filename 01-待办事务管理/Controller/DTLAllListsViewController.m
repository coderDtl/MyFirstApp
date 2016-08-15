//
//  DTLAllListsViewController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLAllListsViewController.h"
#import "DTLChecklistViewController.h"
#import "DTLAddOrEditListViewController.h"
#import "DTLChecklist.h"
#import "DTLChecklistItem.h"
#import "DTLDataModel.h"

@interface DTLAllListsViewController() <DTLAddOrEditListViewControllerDelegate, UINavigationControllerDelegate>

@end

@implementation DTLAllListsViewController

static NSString * const listCellID = @"listCell";
static NSString * const segueIDOfshowChecklist = @"showChecklist";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    
    NSInteger index = [self.dataModel indexOfSelectedChecklist];
    
    if (index >= 0 && index < self.dataModel.lists.count) { // 最后显示的不是当前控制器，并且index要和模型同步
        DTLChecklist *checklist = self.dataModel.lists[index];
        [self performSegueWithIdentifier:segueIDOfshowChecklist sender:checklist];
    }
}

/** 控制器跳转前调用 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueIDOfshowChecklist]) {
        DTLChecklistViewController *checklistVC = segue.destinationViewController;
        
        // 传递模型
        checklistVC.checklist = sender;
    } else if ([segue.identifier isEqualToString:@"addChecklist"]) {
        UINavigationController *nav = segue.destinationViewController;
        DTLAddOrEditListViewController *addOrEditListVC = (DTLAddOrEditListViewController *)nav.topViewController;
        
        // 设置代理
        addOrEditListVC.delegate = self;
    }
}

#pragma mark - DTLAddOrEditListViewControllerDelegate
- (void)addOrEditListViewController:(DTLAddOrEditListViewController *)controller didFinishAddingList:(DTLChecklist *)list
{
    // 添加模型到数组
    [self.dataModel.lists addObject:list];
    
    // 排序
    [self.dataModel sortChecklists];
    
    // 刷新表格
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addOrEditListViewController:(DTLAddOrEditListViewController *)controller didFinishEditingList:(DTLChecklist *)list
{
    // 排序
    [self.dataModel sortChecklists];
    
    // 刷新表格
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addOrEditListViewControllerDidCancel:(DTLAddOrEditListViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:listCellID];
    }
    
    DTLChecklist *list = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = list.name;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSInteger count = [list countUncheckedItems];
    if (list.items.count == 0) {
        cell.detailTextLabel.text = @"(还没有事务)";
    } else if (count == 0) {
        cell.detailTextLabel.text = @"已全部完成！";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd个事务待完成", count];
    }
    
    // 设置图片
    cell.imageView.image = [UIImage imageNamed:list.iconName];
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTLChecklist *checklist = self.dataModel.lists[indexPath.row];
    
    // 保存选中的行号
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    
    // 点击cell执行segue，并传入模型
    [self performSegueWithIdentifier:segueIDOfshowChecklist sender:checklist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/** 监听cell的信息按钮的点击 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DTLChecklist *checklist = self.dataModel.lists[indexPath.row];
    
    // 通过storyBoard初始化编辑类别控制器
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"addOrEditListNav"];
    DTLAddOrEditListViewController *addOrEditListVC = (DTLAddOrEditListViewController *)nav.topViewController;
    // 传递模型
    addOrEditListVC.listToEdit = checklist;
    // 设置代理
    addOrEditListVC.delegate = self;
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - navigationController delegate
/** 通过导航控制器跳转页面会调用 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) { // 显示的是当前控制器
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}

@end
