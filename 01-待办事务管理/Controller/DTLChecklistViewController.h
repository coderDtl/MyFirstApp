//
//  DTLChecklistViewController.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/3.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLChecklist;

@interface DTLChecklistViewController : UITableViewController

/** 事务类别模型 */
@property(strong, nonatomic) DTLChecklist *checklist;

@end
