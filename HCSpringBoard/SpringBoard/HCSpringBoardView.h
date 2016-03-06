//
//  HCSpringBoardView.h
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCFavoriteIconModel.h"

@interface HCSpringBoardView : UIView

@property (nonatomic, strong) NSMutableArray *favoriteModelArray;
@property (nonatomic, strong) NSMutableArray *favoriteViewArray;

- (instancetype)initWithFrame:(CGRect)frame modes:(NSMutableArray *)models;

@end
