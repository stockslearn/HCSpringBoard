//
//  ViewController.h
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCAssistant.h"
#import "HCFavoriteIconModel.h"
#import "NSObject+YYModel.h"
#import "HCSpringBoardView.h"
@interface ViewController : UIViewController <BankListDelegate> {
    HCFavoriteIconModel *_favoriteMainMenu;
}

@property (nonatomic, strong) HCFavoriteIconModel *favoriteMainMenu;

- (void)displayMenu;

@end

