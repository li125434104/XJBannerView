

//
//  XJBannerView.m
//  XJBannerViewDemo
//
//  Created by LXJ on 2016/11/28.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import "XJBannerView.h"
#import "XJBannerCell.h"

#define TOTAL_ITEMS (self.itemCount * 20000)
#define PAGE_CONTROL_HEIGHT 32.0

@interface XJBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger itemCount;//显示item的个数
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XJBannerView

@synthesize shouldLoop = _shouldLoop;
@synthesize pageControl = _pageControl;
@synthesize autoScroll = _autoScroll;
@synthesize scrollInterval = _scrollInterval;

static NSString *banner_cell = @"banner_cell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame {
    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
    
    if (CGRectEqualToRect(self.pageControlFrame, CGRectZero)) {
        CGFloat w = self.frame.size.width;
        CGFloat h = PAGE_CONTROL_HEIGHT;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - h;
        self.pageControl.frame = CGRectMake(x, y, w, h);
    }
}


#pragma mark - CollectionView DataSouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.shouldLoop) {
        return TOTAL_ITEMS;
    } else {
        return self.itemCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XJBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_cell forIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(banner:viewForItemAtIndex:)]) {
        cell.itemView = [self.dataSource banner:self viewForItemAtIndex:indexPath.item % self.itemCount];
    }
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(banner:viewForItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //pageControl跟随着移动
    NSIndexPath *currentIndexPath = [collectionView indexPathsForVisibleItems].firstObject;
    self.pageControl.currentPage = currentIndexPath.item % self.itemCount;
}

#pragma mark - Setter & Getter
#pragma mark 属性
- (void)setDataSource:(id<XJBannerViewDataSource>)dataSource {
    
    _dataSource = dataSource;
    [self reloadData];
}

- (NSInteger)itemCount {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBannber:)]) {
        return [self.dataSource numberOfItemsInBannber:self];
    }
    return 0;
}


/**
 循环滚动
 */
- (void)setShouldLoop:(BOOL)shouldLoop {
    _shouldLoop = shouldLoop;
}

- (BOOL)shouldLoop {
    if (self.itemCount == 1) {
        return NO;
    }
    return _shouldLoop;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (BOOL)autoScroll {
    if (self.itemCount < 2) {
        return  NO;
    }
    return _autoScroll;
}

- (void)setScrollInterval:(CGFloat)scrollInterval {
    _scrollInterval = scrollInterval;
    [self startTimer];
}

- (CGFloat)scrollInterval {
    if (!_scrollInterval) {
        _scrollInterval = 3.0;
    }
    return _scrollInterval;
}

- (void)setPageControl:(UIPageControl *)pageControl {
    [_pageControl removeFromSuperview];
    // 赋值
    _pageControl = pageControl;
    
    // 添加新pageControl
    _pageControl.userInteractionEnabled = NO;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    [self reloadData];
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    self.pageControl.frame = pageControlFrame;
}

#pragma mark 控件
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        [_collectionView registerClass:[XJBannerCell class] forCellWithReuseIdentifier:banner_cell];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    
    return _flowLayout;
}

#pragma mark - Private
- (void)reloadData {
    
    if (!self.dataSource || self.itemCount == 0) {
        return;
    }
    
    self.pageControl.numberOfPages = self.itemCount;
    
    [self.collectionView reloadData];
}

#pragma mark - NSTimer
- (void)startTimer {
    if (!self.autoScroll) return;
    
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoScrollToNextItem {
    if (self.itemCount == 0 || self.itemCount == 1 || !self.autoScroll) return;
    
    NSIndexPath *currentIndexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    NSInteger currentItem = currentIndexPath.item;
    NSInteger nextItem = currentItem + 1;
    
    if (nextItem >= TOTAL_ITEMS) return;
    
    if (self.shouldLoop) {
        //无限往下翻
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    } else {
        if ((currentItem % self.itemCount) == self.itemCount - 1) {
            //最后一张，回到第0张
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
}





@end
