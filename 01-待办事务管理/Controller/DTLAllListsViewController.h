//
//  DTLAllListsViewController.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/5.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLDataModel;

@interface DTLAllListsViewController : UITableViewController

/** 接收数据模型 */
@property(strong, nonatomic) DTLDataModel *dataModel;

@end
