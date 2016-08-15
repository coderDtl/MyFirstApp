//
//  DTLAddOrEditListViewController.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLAddOrEditListViewController;
@class DTLChecklist;

@protocol DTLAddOrEditListViewControllerDelegate <NSObject>

- (void)addOrEditListViewControllerDidCancel:(DTLAddOrEditListViewController *)controller;
- (void)addOrEditListViewController:(DTLAddOrEditListViewController *)controller didFinishAddingList:(DTLChecklist *)list;
- (void)addOrEditListViewController:(DTLAddOrEditListViewController *)controller didFinishEditingList:(DTLChecklist *)list;

@end

@interface DTLAddOrEditListViewController : UITableViewController

/** 编辑的类别 */
@property(strong, nonatomic) DTLChecklist *listToEdit;

@property (weak, nonatomic) id<DTLAddOrEditListViewControllerDelegate> delegate;

@end
