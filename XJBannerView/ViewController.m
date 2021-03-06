//
//  ViewController.m
//  XJBannerView
//
//  Created by LXJ on 2016/12/20.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import "ViewController.h"
#import "XJBannerView.h"
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<XJBannerViewDataSource, XJBannerViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XJBannerView *bannerView = [[XJBannerView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 200)];
    bannerView.dataSource = self;
    bannerView.delegate = self;
    bannerView.shouldLoop = YES;
    bannerView.autoScroll = YES;
    [self.view addSubview:bannerView];
}

#pragma mark - XJBannerViewDataSource

- (NSInteger)numberOfItemsInBannber:(XJBannerView *)banner {
    return self.dataArray.count;
}

- (UIView *)banner:(XJBannerView *)banner viewForItemAtIndex:(NSInteger)index {
    NSString *imageStr = self.dataArray[index];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:imageStr]];
    return imageView;
}

#pragma mark - XJBannerViewDelegate
- (void)banner:(XJBannerView *)banner didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击的图片是第%ld张",(long)index);
}


#pragma mark - Getter
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"ad_0", @"ad_1", @"ad_2"];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
