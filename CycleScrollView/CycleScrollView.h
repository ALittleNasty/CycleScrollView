//
//  CycleScrollView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EnumCycleDirectionPortait,          // 垂直滚动
    EnumCycleDirectionLandscape         // 水平滚动
}EnumCycleDirection;

@protocol CycleScrollViewDelegate;
//@protocol CycleScrollViewDataSource;



@interface CycleScrollView : UIView <UIScrollViewDelegate> 

@property(nonatomic, assign) id<CycleScrollViewDelegate>        delegate;
//@property(nonatomic, assign) id<CycleScrollViewDataSource>      dataSource;
@property(nonatomic, assign) BOOL                               isShowUIPageControl;

- (id)initWithFrame:(CGRect)frame cycleDirection:(EnumCycleDirection)direction cycleViews:(NSArray *)cycleViews bgView:(UIView *)bgView;

- (void)refreshScrollView;

- (void)startTimer;

- (void)cleanUpTimerAndCache;

@end







//@protocol CycleScrollViewDataSource <NSObject>
//
// @optional
//
//- (NSInteger)cycleScrollViewNumberOfRows:(CycleScrollView *)cycleScrollView;
//
//- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewForIndex:(NSInteger)index;
//
//@end



@protocol CycleScrollViewDelegate <NSObject>

 @optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectView:(int)index;

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollView:(int)index;

@end