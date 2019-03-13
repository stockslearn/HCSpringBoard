//
//  ViewController.m
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSMutableArray *_iconModelsArray;
    
    HCSpringBoardView *_springBoard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取序列化到本地的所有菜单
    NSDictionary *mainMenuDict = [[NSDictionary alloc]initWithContentsOfFile:DOCUMENT_FOLDER(kMenuFileName)];
    _favoriteMainMenu = [HCFavoriteIconModel modelWithDictionary:mainMenuDict];
    [self displayMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_springBoard) {
        if (_springBoard.isEdit) {
            [_springBoard showEditButton];
        }
    }
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
    
    //根据数据显示菜单
    CGRect sbRect = CGRectMake(0, 100, kScreenSize.width, [self getOnePageRomByDevice]*(ICONIMG_HEIGHT+0.5)+40);
    _springBoard = [[HCSpringBoardView alloc]initWithFrame:sbRect modes:_iconModelsArray];
    _springBoard.springBoardDelegate = self;
    _springBoard.tag = SpringBoardTag;
    [self.view addSubview:_springBoard];
}

#pragma mark - BankListDelegate
//显示在列表页勾选图标
- (void)addIconDone:(HCBankListViewController *)bankListViewController {
    CGRect sbRect = CGRectMake(0, 100, kScreenSize.width, [self getOnePageRomByDevice]*(ICONIMG_HEIGHT+0.5)+40);
    
    [_springBoard removeFromSuperview];
    _springBoard = [[HCSpringBoardView alloc]initWithFrame:sbRect modes:_iconModelsArray];
    _springBoard.springBoardDelegate = self;
    _springBoard.tag = SpringBoardTag;
    [self.view addSubview:_springBoard];
    
    //序列化
    [_springBoard archiverIconModelsArray];
    [_springBoard archiverLoveMenuMainModel];
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

- (NSInteger)getOnePageRomByDevice {
    NSInteger row = 3;
    if (IPHONE6Plus){
        row = 4;
    }
    return row;
}

/*
{
    kImage = "";
    kItems =     (
                  {
                      kItems =             (
                                            {
                                                kImage = "\U8d26\U6237\U7ba1\U7406";
                                                kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>0|CSIIAccMangerViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 39;
                                                                                  kNodeName = "\U8d26\U6237\U603b\U89c8";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIAccOverViewViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>0|CSIIAccMangerViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 40;
                                                                                  kNodeName = "\U4ea4\U6613\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIITradingQueryNextViewController;
                                                                                  kSortNum = 2;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>0|CSIIAccMangerViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 41;
                                                                                  kNodeName = "\U6302\U5931";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIAccLostViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>0|CSIIAccMangerViewController>3";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 42;
                                                                                  kNodeName = "\U7535\U5b50\U56de\U5355";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIAccOverViewViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                kNodeName = "\U8d26\U6237\U7ba1\U7406";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kItems =                             (
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 1;
                                                                                                                            kIsReadOnly = 1;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>0";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 25;
                                                                                                                            kNodeName = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIITHTransferViewController;
                                                                                                                            kSortNum = 0;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U8de8\U884c\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U8de8\U884c\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 1;
                                                                                                                            kIsReadOnly = 1;
                                                                                                                            kMenuListImage = "\U8de8\U884c\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>1";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 26;
                                                                                                                            kNodeName = "\U8de8\U884c\U8f6c\U8d26";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIKHTransferViewController;
                                                                                                                            kSortNum = 1;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 0;
                                                                                                                            kIsReadOnly = 0;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>2";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 27;
                                                                                                                            kNodeName = "\U624b\U673a\U53f7\U8f6c\U8d26";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIPhoneNoTransViewController;
                                                                                                                            kSortNum = 2;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 0;
                                                                                                                            kIsReadOnly = 0;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>3";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 28;
                                                                                                                            kNodeName = "\U5173\U8054\U8d26\U6237\U8f6c\U8d26";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIRelateTransferViewController;
                                                                                                                            kSortNum = 0;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 0;
                                                                                                                            kIsReadOnly = 0;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>4";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 29;
                                                                                                                            kNodeName = "\U9884\U7ea6\U8f6c\U8d26";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIAppThansferViewController;
                                                                                                                            kSortNum = 0;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 0;
                                                                                                                            kIsReadOnly = 0;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>5";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 30;
                                                                                                                            kNodeName = "\U6536\U6b3e\U4eba\U767b\U8bb0\U7c3f\U7ba1\U7406";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIReceiverListViewController;
                                                                                                                            kSortNum = 0;
                                                                                                                        },
                                                                                                                        {
                                                                                                                            kImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kImageSeleted = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kIsDisplay = 0;
                                                                                                                            kIsReadOnly = 0;
                                                                                                                            kMenuListImage = "\U884c\U5185\U8f6c\U8d26";
                                                                                                                            kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>0|CSIITransferViewController>6";
                                                                                                                            kNeedLogin = 1;
                                                                                                                            kNodeIndex = 31;
                                                                                                                            kNodeName = "\U8f6c\U8d26\U7535\U8bdd\U6536\U6b3e\U4eba\U7ba1\U7406";
                                                                                                                            kNodeType = Viewcontroller;
                                                                                                                            kSendController = CSIIReceiverListViewController;
                                                                                                                            kSortNum = 0;
                                                                                                                        }
                                                                                                                        );
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNodeName = "\U8f6c\U8d26\U6c47\U6b3e";
                                                                                  kNodeType = MenuList;
                                                                              },
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>2|CNYReturnAccViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 34;
                                                                                  kNodeName = "\U4fe1\U7528\U5361\U8fd8\U6b3e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CNYCreditReturnViewController;
                                                                                  kSortNum = 5;
                                                                              },
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 35;
                                                                                  kNodeName = "\U4e8c\U7ef4\U7801\U8f6c\U8d26";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIQRTransferViewController;
                                                                                  kSortNum = 5;
                                                                              },
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>3";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 36;
                                                                                  kNodeName = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = SavWithTimViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>4";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 37;
                                                                                  kNodeName = "\U901a\U77e5\U5b58\U6b3e\U8f6c\U8d26";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIINotifyDepositViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kImageSeleted = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>1|CSIIAutoTransferViewController>5";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 38;
                                                                                  kNodeName = "\U7b2c\U4e09\U65b9\U5b58\U7ba1";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CNYThirdPartyViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U81ea\U52a9\U8f6c\U8d26";
                                                kNodeName = "\U81ea\U52a9\U8f6c\U8d26";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U6295\U8d44\U7406\U8d22";
                                                kImageSeleted = "\U6295\U8d44\U7406\U8d22";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U6295\U8d44\U7406\U8d22";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>2";
                                                kNeedLogin = 1;
                                                kNodeIndex = 47;
                                                kNodeName = "\U6295\U8d44\U7406\U8d22";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIFinancingViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                kImageSeleted = "\U8d37\U6b3e\U7ba1\U7406";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>4|loanControlViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 43;
                                                                                  kNodeName = "\U989d\U5ea6\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = LoanLimitViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>4|loanControlViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 44;
                                                                                  kNodeName = "\U8d37\U6b3e\U660e\U7ec6\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = loanDetailFirstViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>4|loanControlViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 45;
                                                                                  kNodeName = "\U8fd8\U6b3e\U5386\U53f2\U8bb0\U5f55\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = LoanHistoryViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U8d37\U6b3e\U7ba1\U7406";
                                                kNodeName = "\U8d37\U6b3e\U7ba1\U7406";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U7279\U8272\U670d\U52a1";
                                                kImageSeleted = "\U7279\U8272\U670d\U52a1";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U65e0\U5361\U53d6\U6b3e";
                                                                                  kImageSeleted = "\U65e0\U5361\U53d6\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U65e0\U5361\U53d6\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>5|XHHUiqSerViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 46;
                                                                                  kNodeName = "\U65e0\U5361\U53d6\U6b3e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHNoCaFeViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U7279\U8272\U670d\U52a1";
                                                kNodeName = "\U7279\U8272\U670d\U52a1";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U751f\U6d3b\U7f34\U8d39";
                                                kImageSeleted = "\U751f\U6d3b\U7f34\U8d39";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kImageSeleted = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>5|CSIILifePayIndexViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 32;
                                                                                  kNodeName = "\U7535\U4fe1\U5145\U503c";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIElectricChargeIndexViewController;
                                                                                  kSortNum = 5;
                                                                              },
                                                                              {
                                                                                  kImage = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kImageSeleted = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U751f\U6d3b\U7f34\U8d39";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>5|CSIILifePayIndexViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 33;
                                                                                  kNodeName = "\U6c34\U8d39\U7f34\U8d39";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIWaterChargesViewController;
                                                                                  kSortNum = 5;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U751f\U6d3b\U7f34\U8d39";
                                                kNodeName = "\U751f\U6d3b\U7f34\U8d39";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U5ba2\U6237\U79ef\U5206";
                                                kImageSeleted = "\U5ba2\U6237\U79ef\U5206";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U5ba2\U6237\U79ef\U5206";
                                                kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>3|CSIIDebitCardViewController>6";
                                                kNeedLogin = 1;
                                                kNodeIndex = 48;
                                                kNodeName = "\U5ba2\U6237\U79ef\U5206";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIIntegralQueryViewController;
                                                kSortNum = 0;
                                            }
                                            );
                      kMenuListImage = "\U501f\U8bb0\U5361";
                      kNodeName = "\U501f\U8bb0\U5361";
                      kNodeType = MenuIcons;
                  },
                  {
                      kItems =             (
                                            {
                                                kImage = "\U8d26\U6237\U7ba1\U7406";
                                                kImageSeleted = "\U8d26\U6237\U7ba1\U7406";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U8d26\U6237\U7ba1\U7406";
                                                kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>0";
                                                kNeedLogin = 1;
                                                kNodeIndex = 60;
                                                kNodeName = "\U8d26\U6237\U7ba1\U7406";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIAccOverViewViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>1|CSIICreditCardSearchViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 49;
                                                                                  kNodeName = "\U529e\U5361\U8fdb\U5ea6\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIICreditCardProgressViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>1|CSIICreditCardSearchViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 50;
                                                                                  kNodeName = "\U4fe1\U7528\U5361\U8d26\U6237\U4fe1\U606f\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIAccInfoViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>1|CSIICreditCardSearchViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 51;
                                                                                  kNodeName = "\U5df2\U51fa\U8d26\U5355\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIICheckedOutPayListViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>1|CSIICreditCardSearchViewController>3";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 52;
                                                                                  kNodeName = "\U672a\U51fa\U8d26\U5355\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIUnCheckedPayListViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kImageSeleted = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>1|CSIICreditCardSearchViewController>4";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 53;
                                                                                  kNodeName = "\U5386\U53f2\U4ea4\U6613\U67e5\U8be2";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIHistoryViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                kNodeName = "\U4fe1\U7528\U5361\U67e5\U8be2";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                kImageSeleted = "\U8fd8\U6b3e\U7ba1\U7406";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>2|CNYReturnAccViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 54;
                                                                                  kNodeName = "\U4fe1\U7528\U5361\U8fd8\U6b3e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CNYCreditReturnViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kImageSeleted = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>2|CNYReturnAccViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 55;
                                                                                  kNodeName = "\U81ea\U52a8\U8fd8\U6b3e\U8bbe\U7f6e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CNYAutoReturnViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U8fd8\U6b3e\U7ba1\U7406";
                                                kNodeName = "\U8fd8\U6b3e\U7ba1\U7406";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U5206\U671f\U7ba1\U7406";
                                                kImageSeleted = "\U5206\U671f\U7ba1\U7406";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kImageSeleted = "\U5206\U671f\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>3|XHHBudMangViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 56;
                                                                                  kNodeName = "\U9884\U501f\U73b0\U91d1";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHPreCashViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kImageSeleted = "\U5206\U671f\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>3|XHHBudMangViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 57;
                                                                                  kNodeName = "\U8d26\U5355\U5206\U671f";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHBillStageOfaViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kImageSeleted = "\U5206\U671f\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5206\U671f\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>3|XHHBudMangViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 58;
                                                                                  kNodeName = "\U4ea4\U6613\U5206\U671f";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHTradeInstalViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U5206\U671f\U7ba1\U7406";
                                                kNodeName = "\U5206\U671f\U7ba1\U7406";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U5361\U7247\U7ba1\U7406";
                                                kImageSeleted = "\U5361\U7247\U7ba1\U7406";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U5361\U7247\U7ba1\U7406";
                                                                                  kImageSeleted = "\U5361\U7247\U7ba1\U7406";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5361\U7247\U7ba1\U7406";
                                                                                  kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>4|CreditCardManageViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 59;
                                                                                  kNodeName = "\U4fe1\U7528\U5361\U6fc0\U6d3b";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHCreditCaActViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U5361\U7247\U7ba1\U7406";
                                                kNodeName = "\U5361\U7247\U7ba1\U7406";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U79ef\U5206\U7ba1\U7406";
                                                kImageSeleted = "\U79ef\U5206\U7ba1\U7406";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U79ef\U5206\U7ba1\U7406";
                                                kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>4|CSIICreditCardViewController>5";
                                                kNeedLogin = 1;
                                                kNodeIndex = 61;
                                                kNodeName = "\U79ef\U5206\U7ba1\U7406";
                                                kNodeType = Viewcontroller;
                                                kSendController = XHHIntegerQuryViewController;
                                                kSortNum = 0;
                                            }
                                            );
                      kMenuListImage = "\U4fe1\U7528\U5361";
                      kNodeName = "\U4fe1\U7528\U5361";
                      kNodeType = MenuIcons;
                  },
                  {
                      kItems =             (
                                            {
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>0|SavWithTimViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 66;
                                                                                  kNodeName = "\U6d3b\U671f\U8f6c\U5b9a\U671f";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = SavToTimViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5b9a\U671f\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>0|SavWithTimViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 67;
                                                                                  kNodeName = "\U5b9a\U671f\U8f6c\U6d3b\U671f";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = TimToSavViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U5b9a\U671f\U5b58\U6b3e";
                                                kNodeName = "\U5b9a\U671f\U5b58\U6b3e";
                                                kNodeType = MenuIcons;
                                            },
                                            {
                                                kImage = "\U57fa\U91d1";
                                                kImageSeleted = "\U57fa\U91d1";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U57fa\U91d1";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>1";
                                                kNeedLogin = 1;
                                                kNodeIndex = 70;
                                                kNodeName = "\U57fa\U91d1";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIFundViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kImage = "\U7406\U8d22";
                                                kImageSeleted = "\U7406\U8d22";
                                                kIsDisplay = 1;
                                                kIsReadOnly = 1;
                                                kMenuListImage = "\U7406\U8d22";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>2";
                                                kNeedLogin = 1;
                                                kNodeIndex = 71;
                                                kNodeName = "\U7406\U8d22";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIFinancingViewController;
                                                kSortNum = 2;
                                            },
                                            {
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kImageSeleted = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>3|XHHSepProfViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 68;
                                                                                  kNodeName = "\U6b65\U6b65\U552f\U76c8\U7b7e\U7ea6";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHSetpProfSignViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kImageSeleted = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U6b65\U6b65\U552f\U76c8";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>3|XHHSepProfViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 69;
                                                                                  kNodeName = "\U6b65\U6b65\U552f\U652f\U53d6";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = BBWWZQViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U6b65\U6b65\U552f\U76c8";
                                                kNodeName = "\U6b65\U6b65\U552f\U76c8";
                                                kNodeType = MenuIcons;
                                            },
                                            {
                                                kImage = "\U6c5f\U5357\U76c8";
                                                kImageSeleted = "\U6c5f\U5357\U76c8";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U6c5f\U5357\U76c8";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>4";
                                                kNeedLogin = 1;
                                                kNodeIndex = 72;
                                                kNodeName = "\U6c5f\U5357\U76c8";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIJNYViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>5|CSIINotifyDepositViewController>0";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 62;
                                                                                  kNodeName = "\U6d3b\U671f\U8f6c\U901a\U77e5\U5b58\U6b3e";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIICurrentChangeNotifyDepositViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>5|CSIINotifyDepositViewController>1";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 63;
                                                                                  kNodeName = "\U901a\U77e5\U5b58\U6b3e\U652f\U53d6\U9884\U7ea6";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIITongZhiYuYueViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>5|CSIINotifyDepositViewController>2";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 64;
                                                                                  kNodeName = "\U901a\U77e5\U5b58\U6b3e\U652f\U53d6";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIDrawDepositViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kImageSeleted = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U901a\U77e5\U5b58\U6b3e";
                                                                                  kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>5|CSIINotifyDepositViewController>3";
                                                                                  kNeedLogin = 1;
                                                                                  kNodeIndex = 65;
                                                                                  kNodeName = "\U901a\U77e5\U5b58\U6b3e\U9884\U7ea6\U53d6\U6d88";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIICancelAppointmentViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U901a\U77e5\U5b58\U6b3e";
                                                kNodeName = "\U901a\U77e5\U5b58\U6b3e";
                                                kNodeType = MenuIcons;
                                            },
                                            {
                                                kImage = "\U667a\U80fd\U8f6c\U5b58";
                                                kImageSeleted = "\U667a\U80fd\U8f6c\U5b58";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U667a\U80fd\U8f6c\U5b58";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>6";
                                                kNeedLogin = 1;
                                                kNodeIndex = 73;
                                                kNodeName = "\U667a\U80fd\U8f6c\U5b58";
                                                kNodeType = Viewcontroller;
                                                kSendController = IntelLigentSavViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kImage = "\U79ef\U5b58\U91d1";
                                                kImageSeleted = "\U79ef\U5b58\U91d1";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U79ef\U5b58\U91d1";
                                                kNavigationObject = "CSIITabBarViewController>1|CSIIWealthViewController>7";
                                                kNeedLogin = 1;
                                                kNodeIndex = 74;
                                                kNodeName = "\U79ef\U5b58\U91d1";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIJiCunBuyOrReturnViewController;
                                                kSortNum = 2;
                                            }
                                            );
                      kMenuListImage = "\U7406\U8d22";
                      kNodeName = "\U8d22\U5bcc";
                      kNodeType = MenuIcons;
                  },
                  {
                      kItems =             (
                                            {
                                                kImage = "\U91d1\U878d\U884c\U60c5";
                                                kImageSeleted = "\U91d1\U878d\U884c\U60c5";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kImageSeleted = "\U91d1\U878d\U884c\U60c5";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>0|CSIIGoldMeltListViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 13;
                                                                                  kNodeName = "\U5b58\U6b3e\U5229\U7387";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIILilvAndFundSearchViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kImageSeleted = "\U91d1\U878d\U884c\U60c5";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>0|CSIIGoldMeltListViewController>1";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 14;
                                                                                  kNodeName = "\U8d37\U6b3e\U5229\U7387";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIILilvAndFundSearchViewController;
                                                                                  kSortNum = 1;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kImageSeleted = "\U91d1\U878d\U884c\U60c5";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>0|CSIIGoldMeltListViewController>2";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 15;
                                                                                  kNodeName = "\U57fa\U91d1\U884c\U60c5";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIILilvAndFundSearchViewController;
                                                                                  kSortNum = 2;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kImageSeleted = "\U91d1\U878d\U884c\U60c5";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U884c\U60c5";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>0|CSIIGoldMeltListViewController>3";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 16;
                                                                                  kNodeName = "\U5916\U6c47\U884c\U60c5";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIOutMoneyTransViewController;
                                                                                  kSortNum = 3;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U91d1\U878d\U884c\U60c5";
                                                kNodeName = "\U91d1\U878d\U884c\U60c5";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U91d1\U878d\U8d44\U8baf";
                                                kImageSeleted = "\U91d1\U878d\U8d44\U8baf";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8d44\U8baf";
                                                                                  kImageSeleted = "\U91d1\U878d\U8d44\U8baf";
                                                                                  kIsDisplay = 1;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8d44\U8baf";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>1|CSIIGoldMeltNewsViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 17;
                                                                                  kNodeName = "\U4fdd\U9669\U4ea7\U54c1";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIInsuranceDetailViewController;
                                                                                  kSortNum = 7;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U91d1\U878d\U8d44\U8baf";
                                                kNodeName = "\U91d1\U878d\U8d44\U8baf";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U7533\U8bf7\U8d37\U6b3e";
                                                kImageSeleted = "\U7533\U8bf7\U8d37\U6b3e";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U7533\U8bf7\U8d37\U6b3e";
                                                kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>2";
                                                kNeedLogin = 0;
                                                kNodeIndex = 24;
                                                kNodeName = "\U7533\U8bf7\U8d37\U6b3e";
                                                kNodeType = Viewcontroller;
                                                kSendController = CSIIApplyLoanViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                kImageSeleted = "\U4ea7\U54c1\U8d85\U5e02";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kImageSeleted = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>3|FinaceProductMenuViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 18;
                                                                                  kNodeName = "\U7406\U8d22\U4ea7\U54c1";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIFinancingViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kImageSeleted = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>3|FinaceProductMenuViewController>1";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 19;
                                                                                  kNodeName = "\U9ec4\U91d1\U4ea7\U54c1";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIGoldProductViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U4ea7\U54c1\U8d85\U5e02";
                                                kNodeName = "\U4ea7\U54c1\U8d85\U5e02";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                kImageSeleted = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kImageSeleted = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|XHHHelperCenterViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 20;
                                                                                  kNodeName = "\U8d44\U8d39\U6807\U51c6";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIZFBZViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kImageSeleted = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|XHHHelperCenterViewController>1";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 21;
                                                                                  kNodeName = "\U5e38\U89c1\U95ee\U9898";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHFreAskQuesViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kImageSeleted = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|XHHHelperCenterViewController>2";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 22;
                                                                                  kNodeName = "\U610f\U89c1\U53cd\U9988";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHFeedbackViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kImageSeleted = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|XHHHelperCenterViewController>3";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 23;
                                                                                  kNodeName = "\U670d\U52a1\U70ed\U7ebf";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = XHHServeLineViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U5e2e\U52a9\U4e2d\U5fc31";
                                                kNodeName = "\U5e2e\U52a9\U4e2d\U5fc3";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 0;
                                                                                  kNodeName = "\U5b58\U6b3e\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = DepositCalViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>1";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 1;
                                                                                  kNodeName = "\U8d37\U6b3e\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = LoanCalViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>2";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 2;
                                                                                  kNodeName = "\U7406\U8d22\U6536\U76ca\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = FinancialProfitViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>3";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 3;
                                                                                  kNodeName = "\U5916\U6c47\U5151\U6362\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIWBDHController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>4";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 4;
                                                                                  kNodeName = "\U4fe1\U7528\U5361\U5206\U671f\U8fd8\U6b3e\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIXYKFQController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>5";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 5;
                                                                                  kNodeName = "\U6309\U63ed\U8d37\U6b3e\U6708\U4f9b\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIAJDKController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kImageSeleted = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>4|CNYFinancialCalViewController>6";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 6;
                                                                                  kNodeName = "\U4e2a\U4eba\U6240\U5f97\U7a0e\U8ba1\U7b97\U5668";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = CSIIGRSDSController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                kNodeName = "\U91d1\U878d\U8ba1\U7b97\U5668";
                                                kNodeType = MenuList;
                                            },
                                            {
                                                kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                kItems =                     (
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>0";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 7;
                                                                                  kNodeName = "\U67e5\U8be2\U7f51\U70b9";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>1";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 8;
                                                                                  kNodeName = "\U67e5\U770b\U5468\U56f4\U7f51\U70b9";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>2";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 9;
                                                                                  kNodeName = "\U67e5\U8be2\U8bbe\U5907";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>3";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 10;
                                                                                  kNodeName = "\U67e5\U770b\U5468\U8fb9\U8bbe\U5907";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>4";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 11;
                                                                                  kNodeName = "\U67e5\U8be2\U4fbf\U6c11\U901a";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              },
                                                                              {
                                                                                  kImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kImageSeleted = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kIsDisplay = 0;
                                                                                  kIsReadOnly = 0;
                                                                                  kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                                                  kNavigationObject = "CSIITabBarViewController>3|CSIIHelpViewController>5|CSIIWandDianViewController>5";
                                                                                  kNeedLogin = 0;
                                                                                  kNodeIndex = 12;
                                                                                  kNodeName = "\U67e5\U770b\U5468\U8fb9\U4fbf\U6c11\U901a";
                                                                                  kNodeType = Viewcontroller;
                                                                                  kSendController = WangDianViewController;
                                                                                  kSortNum = 0;
                                                                              }
                                                                              );
                                                kMenuListImage = "\U7f51\U70b9\U67e5\U8be2";
                                                kNodeName = "\U7f51\U70b9\U53ca\U8bbe\U5907\U67e5\U8be2";
                                                kNodeType = MenuList;
                                            }
                                            );
                      kMenuListImage = "\U52a9\U624b_MenuIcon";
                      kNodeName = "\U52a9\U624b";
                      kNodeType = MenuIcons;
                  },
                  {
                      kItems =             (
                                            {
                                                kActionId = YaoYiYao;
                                                kImage = "\U62bd\U5956\U6d3b\U52a8";
                                                kImageSeleted = "\U62bd\U5956\U6d3b\U52a8";
                                                kIsDisplay = 0;
                                                kIsReadOnly = 0;
                                                kMenuListImage = "\U62bd\U5956\U6d3b\U52a8";
                                                kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>1";
                                                kNeedLogin = 1;
                                                kNodeIndex = 75;
                                                kNodeName = "\U6447\U4e00\U6447\U62bd\U5956";
                                                kNodeType = WebNetwork;
                                                kSendController = WebViewController;
                                                kSortNum = 0;
                                            },
                                            {
                                                kActionId = NewYear;
                                                kImage = "\U62bd\U5956\U6d3b\U52a8";
                                                kImageSeleted = "\U62bd\U5956\U6d3b\U52a8";
                                                kIsDisplay = 1;
                                                kIsReadOnly = 1;
                                                kMenuListImage = "\U62bd\U5956\U6d3b\U52a8";
                                                kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>1";
                                                kNeedLogin = 1;
                                                kNodeIndex = 76;
                                                kNodeName = "\U5de5\U4f1a\U5361\U7ea2\U5305";
                                                kNodeType = WebNetwork;
                                                kSendController = WebViewController;
                                                kSortNum = 7;
                                            }
                                            );
                      kMenuListImage = "\U6d3b\U52a8";
                      kNodeName = "\U62bd\U5956\U6d3b\U52a8";
                      kNodeType = MenuIcons;
                  },
                  {
                      kActionId = PreferentialMerchant;
                      kImage = "\U5de5\U4f1a\U5361\U5546\U5708";
                      kImageSeleted = "\U5de5\U4f1a\U5361\U5546\U5708";
                      kIsDisplay = 1;
                      kIsReadOnly = 1;
                      kMenuListImage = "\U5de5\U4f1a\U5361\U5546\U5708";
                      kNavigationObject = "CSIITabBarViewController>0|CSIIFirstViewController>1";
                      kNeedLogin = 1;
                      kNodeIndex = 77;
                      kNodeName = "\U5de5\U4f1a\U5361\U5546\U5708";
                      kNodeType = WebNetwork;
                      kSendController = WebViewController;
                      kSortNum = 5;
                  }
                  );
    kNodeName = "\U6dfb\U52a0\U6211\U7684\U6700\U7231";
    kNodeType = MenuList;
    kTarget = "";
    sortMaxNum = 40;
}
*/

@end
