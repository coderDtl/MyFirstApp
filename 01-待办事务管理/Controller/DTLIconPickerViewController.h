//
//  DTLIconPickerViewController.h
//  01-待办事务管理
//
//  Created by datianlao on 16/8/7.
//  Copyright © 2016年 datianlao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTLIconPickerViewController;

@protocol DTLIconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(DTLIconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface DTLIconPickerViewController : UITableViewController

@property (weak, nonatomic) id<DTLIconPickerViewControllerDelegate> delegate;

@end
