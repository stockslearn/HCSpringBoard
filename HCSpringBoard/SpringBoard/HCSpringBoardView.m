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
    
    UIScrollView *loveScrollView;
    UIPageControl *lovePageControl;
    
    NSMutableArray *pagesView;
}
@end

@implementation HCSpringBoardView

- (instancetype)initWithFrame:(CGRect)frame modes:(NSMutableArray *)models {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        allFrame = [[NSMutableArray alloc]init];
        NSInteger rowOnePage = [self getOnePageRomByDevice];
        iconsOnePageFrameArray = [self getOnePageIconsFrameArrayWithRowNumber:rowOnePage];
        
        //单页icon数
        onePageSize = rowOnePage * 3;
        NSInteger allPageSize = [models count];
        pageCount = [self getPagesNumberWithAllIcon:allPageSize
                                     andOnePageIcon:onePageSize];
        
        //根据有多少页，创建对应的frame，icon直接加到scrollView上。
        allFrame = [self getAllPageIconsFrameArrayWithOnePageRect:iconsOnePageFrameArray
                                                        pageCount:pageCount
                                                   andOnePageIcon:onePageSize];
        
        CGRect scrollRect = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.frame));
        loveScrollView = [[UIScrollView alloc]initWithFrame:scrollRect];
        loveScrollView.bounces = NO;
        loveScrollView.pagingEnabled = YES;
        loveScrollView.backgroundColor = [UIColor whiteColor];
        loveScrollView.showsHorizontalScrollIndicator = NO;
        loveScrollView.showsVerticalScrollIndicator = NO;
        loveScrollView.delegate = self;
        [self addSubview:loveScrollView];
        
        lovePageControl = [[UIPageControl alloc]
                           initWithFrame:CGRectMake(0, CGRectGetMaxY(loveScrollView.frame)+10, ScreenWidth, 20)];
        [lovePageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [lovePageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:0.00f green:0.48f blue:0.88f alpha:1.00f]];
        [self addSubview: lovePageControl];
        
        pagesView = [[NSMutableArray alloc]init];
        for (int i = 0; i < pageCount; i++) {
            UIView *page = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
            page.userInteractionEnabled = YES;
            [self addLineAtPageWithOnePageRow:rowOnePage andPageView:page];
            [pagesView addObject:page];
        }
         [self layoutWithPages:scrollRect];
        
        
    }
    return self;
}
#pragma UIScrollViewDelegate

#pragma mark - 贴上PageView
- (void)layoutWithPages:(CGRect)pageRect{
    loveScrollView.contentOffset = CGPointMake(0.0, 0.0);
    loveScrollView.contentSize = CGSizeMake(CGRectGetWidth(pageRect) * [pagesView count], 0);
    lovePageControl.numberOfPages = [pagesView count];
    lovePageControl.currentPage = 0;
    
    for(int i=0;i<[pagesView count];i++) {
        UIView *page = [pagesView objectAtIndex: i];
        CGRect bounds = page.bounds;
        CGRect frame = CGRectMake(CGRectGetWidth(pageRect) * i, 0.0, CGRectGetWidth(pageRect), CGRectGetHeight(pageRect));
        page.frame = frame;
        page.bounds = bounds;
        [loveScrollView addSubview: page];
    }
}
#pragma mark - 给pageView加横竖线 破代码待优化
- (void)addLineAtPageWithOnePageRow:(NSInteger)rowOnePage andPageView:(UIView *)page {
    //横线
    for (int i=0; i<rowOnePage+1; i++) {
        UILabel *lineLabel = nil;
        if(IPHONE5 || IPHONE6){
            lineLabel = [[UILabel alloc]
                         initWithFrame:CGRectMake(0, i*(ICONIMG_HEIGHT+ICONIMG_VERTICAL-5)+ICONIMG_VERTICAL_SPACE, self.frame.size.width, 0.5)];
        }else{
            lineLabel = [[UILabel alloc]
                         initWithFrame:CGRectMake(0, i*(ICONIMG_HEIGHT+ICONIMG_VERTICAL)+ICONIMG_VERTICAL_SPACE, self.frame.size.width, 0.5)];
        }
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        lineLabel.alpha = 0.5;
        [page addSubview:lineLabel];
    }
    //竖线
    for (int i=0; i<3; i++) {
        UILabel *lineLabel = nil;
        if(IPHONE5 || IPHONE6){
            lineLabel = [[UILabel alloc] initWithFrame:CGRectMake((ICONIMG_WIDTH+0.5)*i+(i-1)*0.5, 0.5, 0.5, rowOnePage*(ICONIMG_HEIGHT+ICONIMG_VERTICAL)+ICONIMG_VERTICAL_SPACE-15)];
        }else{
            lineLabel = [[UILabel alloc] initWithFrame:CGRectMake((ICONIMG_WIDTH+0.5)*i+(i-1)*0.5, 0.5, 0.5, rowOnePage*(ICONIMG_HEIGHT+ICONIMG_VERTICAL)+ICONIMG_VERTICAL_SPACE)];
        }
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        lineLabel.alpha = 0.5;
        [page addSubview:lineLabel];
    }
}
#pragma mark - 计算需要展示的icon的所有Frame
- (NSMutableArray *)getAllPageIconsFrameArrayWithOnePageRect:(NSArray *)onePageArray
                                                   pageCount:(NSInteger)pageCounts
                                              andOnePageIcon:(NSInteger)onePage{
    NSMutableArray *pagesFramesArray = [[NSMutableArray alloc]init];
    indexRectArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < pageCounts; i++) {
        for (NSInteger j = 0; j < onePage; j++) {
            CGRect iconRect = CGRectFromString(onePageArray[j]);
            iconRect.origin.x += i * ScreenWidth;//屏幕宽既是scrollview的宽
            NSString *iconRectString = NSStringFromCGRect(iconRect);
            
            [pagesFramesArray addObject:iconRectString];
            
            NSInteger index = j + onePage*i;
            
            //组织判断区域
            HCIndexRect *indexRect = [[HCIndexRect alloc]initWithIndex:index rect:iconRect];
            [indexRectArray addObject:indexRect];
        }
    }
    
    
    
    return pagesFramesArray;
}
#pragma mark - 判断需要几页
- (NSInteger)getPagesNumberWithAllIcon:(NSInteger)count andOnePageIcon:(NSInteger)onePageCount{
    NSInteger pageCounts = count / onePageCount;
    if (count % onePageCount != 0) {
        pageCounts += 1;
    }
    return pageCounts;
}
#pragma mark - 判断需要多少行高
- (NSInteger)getOnePageRomByDevice {
    NSInteger row = 2;
    if (IPHONE5 || IPHONE6) {
        row = 3;
    }else if (IPHONE6Plus){
        row = 4;
    }
    return row;
}
#pragma mark - 计算九宫格Frame
- (NSArray *)getOnePageIconsFrameArrayWithRowNumber:(NSInteger)row {
    NSMutableArray *iconRectArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < row; i++) {
        for (int j = 0;j < 3; j++) {
            CGRect rect = CGRectMake(j*((ScreenWidth/3)+ICONIMG_LEVEL_SPACE), i*(ICONIMG_HEIGHT+25+ICONIMG_VERTICAL_SPACE), ICONIMG_WIDTH, ICONIMG_HEIGHT+25);
            [iconRectArray addObject:NSStringFromCGRect(rect)];
        }
    }
    return iconRectArray;
}

@end
