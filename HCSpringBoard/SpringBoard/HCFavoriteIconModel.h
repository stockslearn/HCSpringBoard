//
//  HCFavoriteIconModel.h
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
// 所谓的数据结构

#import <Foundation/Foundation.h>

@interface HCFavoriteIconModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *imageSeleted;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL display;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isReadOnly;

@property (nonatomic, copy) NSString *menuListImage;
@property (nonatomic, copy) NSString *navigationPointing;
@property (nonatomic, assign) BOOL isNeedLogin;
@property (nonatomic, copy) NSString *nodeIndex;
@property (nonatomic, assign) NSInteger sortNum;

@property (nonatomic, copy) NSString *targetController;//目标控制器

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *itemList;


@end
