//
//  HCBankListViewController.h
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/7.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCAssistant.h"
@class HCBankListViewController;
@protocol BankListDelegate <NSObject>

- (void)addIconDone:(HCBankListViewController *)bankListViewController;

@end
@interface HCBankListViewController : UITableViewController

@property (nonatomic, assign) id <BankListDelegate> bankListDelegate;
@property (nonatomic, strong) NSMutableArray *allMenuModels;//全菜单的数组，操作数据

- (instancetype)initWithMainMenu:(NSArray *)mainMenu;

@end
