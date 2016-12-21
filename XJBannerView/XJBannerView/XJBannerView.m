

//
//  XJBannerView.m
//  XJBannerViewDemo
//
//  Created by LXJ on 2016/11/28.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import "XJBannerView.h"
#import "XJBannerCell.h"

@interface XJBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger itemCount;//显示item的个数

@end

@implementation XJBannerView

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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame {
    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
}


#pragma mark - CollectionView DataSouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
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
    
    [self.collectionView reloadData];
}

@end
