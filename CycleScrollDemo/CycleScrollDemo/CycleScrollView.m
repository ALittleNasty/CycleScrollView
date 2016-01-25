//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"
#import "SCGIFImageView.h"

@implementation CycleScrollView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray defaultImg:(UIImage *)defaultImg;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGRect (^clearDecimalBlock)(CGRect frame)  = ^(CGRect frame)
        {
            float (^pblock)(float val)  = ^(float val)
            {
                float v = ((int)(val * 10) % 10 < 5) ? (float)((int)val) : (float)((int)val + 0.5);
                return v;
            };
            return CGRectMake(pblock(frame.origin.x), pblock(frame.origin.y), pblock(frame.size.width), pblock(frame.size.height));
        };

        mutlDict = [NSMutableDictionary new];

        self.backgroundColor = [UIColor clearColor];
        scrollFrame = clearDecimalBlock(frame);
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        self.defaultImg = defaultImg;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) 
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        if(scrollDirection == CycleDirectionPortait) 
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }

        [self startTimer];
    }
    
    return self;
}

- (void)startTimer
{
    [self refreshScrollView];

    if (imagesArray && [imagesArray count] > 1)
    {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrollAd:) userInfo:nil repeats:YES];
    }
}


- (void)cleanUpTimerAndCache
{
    if ([autoScrollTimer isValid])
    {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }

    if ([mutlDict count])
    {
        [mutlDict removeAllObjects];
    }

    for (UIView *v in scrollView.subviews)
    {
        [v removeFromSuperview];
    }
}


- (void)refreshScrollView 
{
    if (!imagesArray || [imagesArray count] < 1)
        return;
    
    for (UIView *v in scrollView.subviews)
    {
        [v removeFromSuperview];
    }

    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3 && [curImages count] > i; i++) 
    {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        NSString *imgUrl = [curImages objectAtIndex:i];
        SCGIFImageView *imageView = nil;
        if ([mutlDict.allKeys containsObject:imgUrl] && [imagesArray count] > 1)
        {
            imageView =  [mutlDict objectForKey:imgUrl];
            imageView.frame = CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height);
            [scrollView addSubview:imageView];
        }
        else
        {
            imageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, scrollFrame.size.height)];
            imageView.userInteractionEnabled = YES;
            [imageView getImageWithUrl:imgUrl defaultImg:self.defaultImg successBlock:^{

            } failedBlock:^{

            }];

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];

            [mutlDict setObject:imageView forKey:imgUrl];
            [scrollView addSubview:imageView];
            [imageView release];
        }
            // 水平滚动
        if(scrollDirection == CycleDirectionLandscape)
        {
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        }
            // 垂直滚动
        if(scrollDirection == CycleDirectionPortait)
        {
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        }

        [pool drain];
    }

    if (scrollDirection == CycleDirectionLandscape) 
    {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    
    if (scrollDirection == CycleDirectionPortait) 
    {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page 
{
    if(!imagesArray || [imagesArray count] == 0)
        return nil;
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value
{
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView 
{
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    NSLog(@"did  x=%d  y=%d", x, y);
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) 
    {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) 
        { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        
        if(x <= 0) 
        {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) 
    {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height))
        { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        
        if(y <= 0) 
        {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) 
    {
        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView 
{
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    NSLog(@"--end  x=%d  y=%d", x, y);
    
    if (scrollDirection == CycleDirectionLandscape) 
    {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    
    if (scrollDirection == CycleDirectionPortait) 
    {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)])
    {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

- (void)autoScrollAd:(NSTimer *)timer
{
    if (scrollDirection == CycleDirectionLandscape)
    {
        [scrollView scrollRectToVisible:CGRectMake(2 * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    }
    
    if (scrollDirection == CycleDirectionPortait)
    {
        [scrollView scrollRectToVisible:CGRectMake(0, 2 * self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:YES];
    }
    
    NSLog(@"curPage %d", curPage);
}


- (void)dealloc
{
    [scrollView release];
    [curImageView release];
    [imagesArray release];
    [curImages release];
    
    autoScrollTimer = nil;
    [mutlDict release];

    self.defaultImg = nil;
    
    [super dealloc];
}

@end
