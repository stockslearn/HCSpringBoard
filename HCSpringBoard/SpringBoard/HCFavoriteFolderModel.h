//
//  HCFavoriteFolderModel.h
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/6.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"

@interface HCFavoriteFolderModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *folderName;
@property (nonatomic, strong) NSMutableArray *iconModelsFolderArray;
@property (nonatomic, strong) NSMutableArray *iconViewsFolderArray;

- (void)updateTagFolderModel;

@end
