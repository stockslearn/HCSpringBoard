//
//  HCSpringBoardView.m
//  HCSpringBoard
//
//  Created by 刘海川 on 16/3/4.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "HCSpringBoardView.h"

@interface HCSpringBoardView()
{
    NSMutableArray *allFrame;//几页图标的frame
    
    CGPoint lastPoint;
    NSMutableArray *indexRectArray;//存放IndexRect
    
    NSInteger pageCount;
    NSArray *iconsOnePageFrameArray;
    NSInteger onePageSize ;
}
@end

@implementation HCSpringBoardView

- (instancetype)initWithFrame:(CGRect)frame modes:(NSMutableArray *)models {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
