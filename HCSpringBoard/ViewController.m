//
//  ViewController.m
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    HCFavoriteIconModel *_favoriteMainMenu;
    
    NSMutableArray *_iconModelsArray;
    
    HCSpringBoardView *_springBoard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *mainMenuDict = [[NSDictionary alloc]initWithContentsOfFile:DOCUMENT_FOLDER(kMenuFileName)];
    _favoriteMainMenu = [HCFavoriteIconModel modelWithDictionary:mainMenuDict];
    [self displayMenu];
}

- (void)displayMenu {
    _iconModelsArray = [[NSMutableArray alloc]init];
    //取出要显示的数据
    NSUserDefaults *userDefaultsLoveMenu = [[NSUserDefaults alloc]initWithSuiteName:kUserDefaultSuiteNameLoveMenu];
    NSArray *userDefaultsLoveMenuArray = [userDefaultsLoveMenu objectForKey:kUserDefaultLoveMenuKey];
    if (userDefaultsLoveMenu && userDefaultsLoveMenuArray) {
        NSData *modelsArrayData = [userDefaultsLoveMenu objectForKey:kUserDefaultLoveMenuKey];
        NSArray *modelsArray = [NSKeyedUnarchiver unarchiveObjectWithData:modelsArrayData];
        NSLog(@"modelsArray:%@",modelsArray);
        _iconModelsArray = [modelsArray mutableCopy];
    }
    else {
        [self getDisplayIcon:_favoriteMainMenu];
        HCFavoriteIconModel *addModel = [[HCFavoriteIconModel alloc]init];
        addModel.name = @"添加";
        addModel.image = @"tj";
        addModel.imageSeleted = @"tj";
        addModel.type = kViewcontroller;
        addModel.nodeIndex = @"-1";
        addModel.display = YES;
        addModel.isReadOnly = YES;
        addModel.targetController = @"";
        
        [_iconModelsArray addObject:addModel];
        
        NSData *iconModelsArrayData = [NSKeyedArchiver archivedDataWithRootObject:_iconModelsArray];
        [userDefaultsLoveMenu setObject:iconModelsArrayData forKey:kUserDefaultLoveMenuKey];
        [userDefaultsLoveMenu synchronize];
    }
    
    NSLog(@"displayMenu 显示数据：%@",_iconModelsArray);
    if ([self.view viewWithTag:90]) {
        [_springBoard removeFromSuperview];
    }
    CGRect sbRect = CGRectMake(0, 150, kScreenSize.width, 340);
    _springBoard = [[HCSpringBoardView alloc]initWithFrame:sbRect modes:_iconModelsArray];
    _springBoard.backgroundColor = [UIColor greenColor];
    _springBoard.tag = SpringBoardTag;
    [self.view addSubview:_springBoard];
}

//递归查找需要显示的图标
- (void)getDisplayIcon:(HCFavoriteIconModel *)favoroteModel
{
    if ([favoroteModel.type isEqualToString:kViewcontroller] || [favoroteModel.type isEqualToString:kWebLocal] || [favoroteModel.type isEqualToString:kWebNetwork]) {
        if (favoroteModel.display) {
            [_iconModelsArray addObject:favoroteModel];
        }
    }
    else if ([favoroteModel.type isEqualToString:kMenuList] || [favoroteModel.type isEqualToString:kMenuIcons]) {
        for (int i = 0; i < favoroteModel.itemList.count; i++) {
            [self getDisplayIcon:favoroteModel.itemList[i]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
