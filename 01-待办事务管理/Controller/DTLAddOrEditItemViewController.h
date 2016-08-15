//
//  DTLAddOrEditItemViewController.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLAddOrEditItemViewController;
@class DTLChecklistItem;

@protocol DTLAddOrEditItemViewControllerDelegate <NSObject>

- (void)addOrEditItemViewControllerDidCancel:(DTLAddOrEditItemViewController *)controller;
- (void)addOrEditItemViewController:(DTLAddOrEditItemViewController *)controller didFinishAddingItem:(DTLChecklistItem *)item;
- (void)addOrEditItemViewController:(DTLAddOrEditItemViewController *)controller didFinishEditingItem:(DTLChecklistItem *)item;

@end

@interface DTLAddOrEditItemViewController : UITableViewController

/** 编辑的事务 */
@property(strong, nonatomic) DTLChecklistItem *itemToEdit;

@property (weak, nonatomic) id<DTLAddOrEditItemViewControllerDelegate> delegate;

@end
