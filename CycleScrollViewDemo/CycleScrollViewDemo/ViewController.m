//
//  ViewController.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"
#import "SCGIFImageView.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"第%d张", 1];
    
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
   
    SCGIFImageView *imageView1 = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    imageView1.userInteractionEnabled = YES;
    [imageView1 getImageWithUrl:@"http://icons.iconsmash.com/Layered-Drives/Layered-Drives.jpg" defaultImg:nil successBlock:nil failedBlock:nil];
    [picArray addObject:imageView1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 50, 200, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageView1 addSubview:btn];
//    
//    SCGIFImageView *imageView2 = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    imageView2.userInteractionEnabled = YES;
//    [imageView2 getImageWithUrl:@"http://icons.iconsmash.com/Pastel-Icons/Pastel-Icons.jpg" defaultImg:nil successBlock:nil failedBlock:nil];
//    [picArray addObject:imageView2];
//    
//    SCGIFImageView *imageView3 = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    imageView3.userInteractionEnabled = YES;
//    [imageView3 getImageWithUrl:@"http://icons.iconsmash.com/Shining-Z-Pack/Shining-Z-Pack.jpg" defaultImg:nil successBlock:nil failedBlock:nil];
//    [picArray addObject:imageView3];
//    
//    SCGIFImageView *imageView4 = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    imageView4.userInteractionEnabled = YES;
//    [imageView4 getImageWithUrl:@"http://icons.iconsmash.com/the-last-order-ico/the-last-order-ico.jpg" defaultImg:nil successBlock:nil failedBlock:nil];
//    [picArray addObject:imageView4];
    
//    SCGIFImageView *imageView5 = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    imageView5.userInteractionEnabled = YES;
//    [imageView5 getImageWithUrl:@"http://icons.iconsmash.com/iPhone-icons-win-by-judge/iPhone-icons-win-by-judge.jpg" defaultImg:nil successBlock:nil failedBlock:nil];
//    [picArray addObject:imageView5];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.png"]];
    bgView.frame = CGRectMake(0, 0, 320, 480);
    CycleScrollView *cycle = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                     cycleDirection:CycleDirectionLandscape cycleViews:picArray bgView:bgView];
    cycle.delegate = self;
    cycle.isShowUIPageControl = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycle.isShowUIPageControl = NO;
    });
    [self.view addSubview:cycle];
}

- (void)btnClicked:(UIButton *)sender
{
    [[[UIAlertView alloc] initWithTitle:@"btn click"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles: nil] show];
}

#pragma mark - CycleScrollViewDelegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectView:(int)index
{
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"点击了第%d张", index]
                                 message:nil 
                                delegate:nil 
                       cancelButtonTitle:@"确定" 
                       otherButtonTitles: nil] show];
}

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    self.title = [NSString stringWithFormat:@"第%d张", index];
}

@end