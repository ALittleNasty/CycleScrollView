//
//  CycleScrollImageView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
}CycleDirection;

@protocol CycleScrollImageViewDelegate;





@interface CycleScrollImageView : UIView <UIScrollViewDelegate>
{
    UIScrollView        *scrollView;
    UIImageView         *curImageView;
    
    int                 totalPage;
    int                 curPage;
    CGRect              scrollFrame;
        /// scrollView滚动的方向
    CycleDirection      scrollDirection;
        /// 存放当前滚动的三张图片URL
    NSMutableArray      *curImages;
    
    NSTimer             *autoScrollTimer;
    NSMutableDictionary *mutlDict;
    UIPageControl       *pageControl;
}

@property(nonatomic, weak) id<CycleScrollImageViewDelegate>      delegate;
    /// 存放所有需要滚动的图片URL
@property(nonatomic, strong) NSArray                        *imagesUrlArr;
@property(nonatomic, strong) UIImage                        *defaultImg;

- (int)validPageValue:(NSInteger)value;

- (instancetype)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction
                     pictures:(NSArray *)imagesUrlArr defaultImg:(UIImage *)defaultImg;

- (NSArray *)getDisplayImagesWithCurpage:(int)page;

- (void)refreshScrollView;

- (void)startTimer;

- (void)cleanUpTimerAndCache;

@end









@protocol CycleScrollImageViewDelegate <NSObject>

 @optional
- (void)cycleScrollImageViewDelegate:(CycleScrollImageView *)cycleScrollImageView didSelectImageView:(int)index;
- (void)cycleScrollImageViewDelegate:(CycleScrollImageView *)cycleScrollImageView didScrollImageView:(int)index;

@end





