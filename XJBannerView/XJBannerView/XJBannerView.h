//
//  XJBannerView.h
//  XJBannerViewDemo
//
//  Created by LXJ on 2016/11/28.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJBannerViewDataSource, XJBannerViewDelegate;


@interface XJBannerView : UIView


/**
 是否循环滚动，默认NO
 */
@property (nonatomic, assign) BOOL shouldLoop;

/**
 是否自动滑动，默认NO
 */
@property (nonatomic, assign) BOOL autoScroll;

/**
 自动滑动间隔时间（s），默认是3.0
 */
@property (nonatomic, assign) CGFloat scrollInterval;

/**
 pageControl ,自行配置其大小位置
 */
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) CGRect pageControlFrame;

@property (nonatomic, weak) id<XJBannerViewDataSource> dataSource;
@property (nonatomic, weak) id<XJBannerViewDelegate> delegate;

@end


@protocol XJBannerViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInBannber:(XJBannerView *)banner;
- (UIView *)banner:(XJBannerView *)banner viewForItemAtIndex:(NSInteger)index;

@end

@protocol XJBannerViewDelegate <NSObject>
@optional

- (void)banner:(XJBannerView *)banner didSelectItemAtIndex:(NSInteger)index;

@end
