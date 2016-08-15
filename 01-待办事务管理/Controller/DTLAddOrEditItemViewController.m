//
//  DTLAddOrEditItemViewController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLAddOrEditItemViewController.h"
#import "DTLChecklistItem.h"

static CGFloat const DTLDatePickerHeight = 216;

@interface DTLAddOrEditItemViewController() <UITextFieldDelegate>
/** 文本输入 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTextLabel;

@end

@implementation DTLAddOrEditItemViewController
{
    NSDate *_dueDate;
    BOOL _datePickerIsVisible;
    UIDatePicker *_datePicker;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化导航栏右边按钮
    [self setupRightBarButtonItem];
    
    if (self.itemToEdit) { // 编辑
        self.title = @"编辑事务";
        self.textField.text = self.itemToEdit.text;
        self.controlSwitch.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else { // 添加
        // 默认关闭开关，显示当前时间
        self.controlSwitch.on = NO;
        _dueDate = [NSDate date];
    }
    
    // 更新
    [self updateDuedateLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.controlSwitch.on) {
        self.remindTextLabel.textColor = [UIColor blackColor];
        self.dateTextLabel.textColor = [UIColor blackColor];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

/** 初始化导航栏右边按钮 */
- (void)setupRightBarButtonItem
{
    // 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(50, 44);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    // 监听按钮点击
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    // 自定义导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

/** 更新截止日期 */
- (void)updateDuedateLabel
{
    self.dateLabel.text = [_dueDate dateToString];
}

/** 显示日期选择器 */
- (void)showDatePicker
{
    [self.textField resignFirstResponder];
    
    _datePickerIsVisible = YES;
    
    NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    // dateLabel文字高亮
    self.dateLabel.textColor = DTLRGBColor(4, 168, 235);
    // 插入行
    [self.tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 同步日期选择器
    [_datePicker setDate:_dueDate animated:YES];
}

/** 隐藏日期选择器 */
- (void)hideDatePicker
{
    _datePickerIsVisible = NO;
    
    NSIndexPath *indexPathOfPicker = [NSIndexPath indexPathForRow:2 inSection:1];
    // 恢复文字颜色
    self.dateLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    // 删除picker所在的行
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathOfPicker];
    if (cell != nil) { // 如果有cell才删除
        [self.tableView deleteRowsAtIndexPaths:@[indexPathOfPicker] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - 监听控件方法
- (void)done
{
    if (self.itemToEdit) {
        self.itemToEdit.text = self.textField.text;
        self.itemToEdit.shouldRemind = self.controlSwitch.on;
        self.itemToEdit.dueDate = _dueDate;
        // 安排通知
        [self.itemToEdit scheduleNotification];
        
        [self.delegate addOrEditItemViewController:self didFinishEditingItem:self.itemToEdit];
    } else {
        DTLChecklistItem *item = [[DTLChecklistItem alloc] init];
        item.text = self.textField.text;
        item.checked = NO;
        item.shouldRemind = self.controlSwitch.on;
        item.dueDate = _dueDate;
        // 安排通知
        [item scheduleNotification];
        
        [self.delegate addOrEditItemViewController:self didFinishAddingItem:item];
    }
}

- (IBAction)doneForKeyBoard
{
    [self done];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.delegate addOrEditItemViewControllerDidCancel:self];
}

- (void)dateChanged:(UIDatePicker *)datePicker
{
    _dueDate = datePicker.date;
    
    [self updateDuedateLabel];
}

- (IBAction)pickerAveilable:(UISwitch *)sender
{
    if (sender.on) {
        self.remindTextLabel.textColor = [UIColor blackColor];
        self.dateTextLabel.textColor = [UIColor blackColor];
        [self showDatePicker];
    } else {
        self.remindTextLabel.textColor = [UIColor lightGrayColor];
        self.dateTextLabel.textColor = [UIColor lightGrayColor];
        [self hideDatePicker];
    }
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && _datePickerIsVisible) {
        return 3;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) { // 自定义cell
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, DTLScreenWidth, DTLDatePickerHeight)];
        [cell.contentView addSubview:picker];
        _datePicker = picker;
        
        [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    } else { // 显示storyboard的cell
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return DTLDatePickerHeight;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_datePickerIsVisible) {
        [self hideDatePicker];
    } else {
        [self showDatePicker];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1 && self.controlSwitch.on) {
        return indexPath;
    } else {
        // 返回nil，表示所有行cell不接收点击事件
        return nil;
    }
}

/**
 * 通过下面的代理方法告诉tableView我们创建了一个日期选择cell
 */
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - textField delegate
/** 监听textField输入 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 用最新的文字覆盖原来的文字
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = (newStr.length);
//    NSLog(@"%@ --- %zd --- %zd", textField.text, textField.text.length, newStr.length);
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_datePickerIsVisible) {
        [self hideDatePicker];
    }
}

@end
