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
