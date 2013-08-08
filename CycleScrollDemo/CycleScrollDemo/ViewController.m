//
//  ViewController.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"

@interface ViewController ()

@end




@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"第%d张", 1];
    
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
//    [picArray addObject:[UIImage imageNamed:@"0.jpg"]];
//    [picArray addObject:[UIImage imageNamed:@"1.jpg"]];
//    [picArray addObject:[UIImage imageNamed:@"2.jpg"]];
//    [picArray addObject:[UIImage imageNamed:@"3.jpg"]];
    
    [picArray addObject:[[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"]];
    [picArray addObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
    [picArray addObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
    [picArray addObject:@"http://icons.iconsmash.com/Layered-Drives/Layered-Drives.jpg"];
    [picArray addObject:@"http://icons.iconsmash.com/Pastel-Icons/Pastel-Icons.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/Shining-Z-Pack/Shining-Z-Pack.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/the-last-order-ico/the-last-order-ico.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/iPhone-icons-win-by-judge/iPhone-icons-win-by-judge.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/Black-Blue-win/Black-Blue-win.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/IconsLandVistaHardwareDevicesIconsV2Demo/IconsLandVistaHardwareDevicesIconsV2Demo.jpg"];
//    [picArray addObject:@"http://icons.iconsmash.com/Starwars-icons-win/Starwars-icons-win.jpg"];
    
    CycleScrollView *cycle = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                     cycleDirection:CycleDirectionLandscape
                                                           pictures:picArray defaultImg: [UIImage imageNamed:@"3.png"]];
    cycle.delegate = self;
    [self.view addSubview:cycle];
    [cycle release];
    
    [picArray release];
}

#pragma mark - CycleScrollViewDelegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index
{
    
    [[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"点击了第%d张", index] 
                                 message:nil 
                                delegate:nil 
                       cancelButtonTitle:@"确定" 
                       otherButtonTitles: nil] autorelease] show];
}

- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index 
{

    self.title = [NSString stringWithFormat:@"第%d张", index];
}



#pragma mark CycleScrollViewDelegate End -

- (void)dealloc
{
    
    [super dealloc];
}

@end