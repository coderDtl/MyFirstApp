//
//  DTLAddOrEditListViewController.m
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import "DTLAddOrEditListViewController.h"
#import "DTLIconPickerViewController.h"
#import "DTLChecklist.h"

@interface DTLAddOrEditListViewController() <UITextFieldDelegate, DTLIconPickerViewControllerDelegate>
/** 文本输入 */
@property (weak, nonatomic) IBOutlet UITextField *textField;
/** 图标 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 显示图片名 */
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@end

@implementation DTLAddOrEditListViewController
{
    NSString *_iconName;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _iconName = @"Folder";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化导航栏右边按钮
    [self setupRightBarButtonItem];
    
    if (self.listToEdit) {
        self.title = @"编辑类别";
        self.textField.text = self.listToEdit.name;
        _iconName = self.listToEdit.iconName;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    // 设置第二组cell的图片文字
    self.iconLabel.text = _iconName;
    self.iconImageView.image = [UIImage imageNamed:_iconName];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pickIcon"]) {
        DTLIconPickerViewController *iconPickerVC = segue.destinationViewController;
        iconPickerVC.delegate = self;
    }
}

#pragma mark - 按钮点击处理
- (void)done
{
    if (self.listToEdit) { // 编辑已有的list
        self.listToEdit.name = self.textField.text;
        self.listToEdit.iconName = _iconName;
        [self.delegate addOrEditListViewController:self didFinishEditingList:self.listToEdit];
    } else { // 添加新的list
        DTLChecklist *list = [[DTLChecklist alloc] init];
        list.name = self.textField.text;
        list.iconName = _iconName;
        
        [self.delegate addOrEditListViewController:self didFinishAddingList:list];
    }
}

- (IBAction)doneForKeyBoard
{
    [self done];
}

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self.delegate addOrEditListViewControllerDidCancel:self];
}

#pragma mark - DTLIconPickerViewControllerDelegate
- (void)iconPicker:(DTLIconPickerViewController *)picker didPickIcon:(NSString *)iconName
{
    // 保存图片名
    _iconName = iconName;
    
    // 设置
    self.iconLabel.text = iconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) { // 第二组就能点击
        return indexPath;
    } else {
        // 返回nil，表示所有行cell不接收点击事件
        return nil;
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

@end
