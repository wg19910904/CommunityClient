//  YFIndexIndicatorView.m
//
//
//  Created by YangFei on 2018/4/10.
//  Copyright © 2018年 YangFei. All rights reserved.
//

#import "YFIndexIndicatorView.h"
#import "IndexIndicatorCell.h"
#import "YFTool.h"

#define IndicatorLineH 2

@interface YFIndexIndicatorView()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewAutoFlowLayoutDelegate>{
    NSInteger current_selected_index;
}
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *indicatroLineView;
@property(nonatomic,assign)BOOL is_first;// 第一次加载
@end

@implementation YFIndexIndicatorView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSizeType = ItemSizeEqualHeight;
    flowLayout.numberOfLines = 1;
    flowLayout.interSpace = 0;
    flowLayout.delegate = self;

    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[IndexIndicatorCell class] forCellWithReuseIdentifier:@"IndexIndicatorCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.is_first = YES;
}

-(void)layoutSubviews{
    self.collectionView.frame = self.bounds;
    if (_showIndicatorLineView) {
        [self.collectionView addSubview:self.indicatroLineView];
        CGRect frame = CGRectMake(_indicatroLineView.frame.origin.x, _indicatroLineView.frame.origin.y, _indicatorLineWidth, _indicatroLineView.bounds.size.height);
        _indicatroLineView.frame = frame;
        _indicatroLineView.backgroundColor = self.indicatorLineColor;
    }
    _indicatroLineView.hidden = !_showIndicatorLineView;
   
}

#pragma mark ====== YFCollectionViewAutoFlowLayoutDelegate =======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    if (self.scrollEnabled) {
        NSString *title = self.index_arr[indexPath.item][@"title"];
        CGFloat width = getSize(title,self.collectionView.frame.size.height,14).width;
        width = _showAnmation ?( width * 1.3 + 10): width;

        return CGSizeMake(width, self.collectionView.frame.size.height);
    }else{
        CGFloat width = self.collectionView.frame.size.width / self.index_arr.count;
        return CGSizeMake(width, self.collectionView.frame.size.height);
    }
}

#pragma mark ====== UICollectionViewDataSource =======
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.index_arr.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IndexIndicatorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexIndicatorCell" forIndexPath:indexPath];
    [cell realoadCellWith:self.index_arr[indexPath.item][@"title"] count:self.index_arr[indexPath.item][@"badge"]];
    cell.show_scale_animation = self.showAnmation;

    return cell;
}

#pragma mark ====== UICollectionViewDelegate =======

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    current_selected_index = indexPath.item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexIndicatorView:didSelectItemAtIndex:)]) {
        [self.delegate indexIndicatorView:self didSelectItemAtIndex:indexPath.item];
    }
    
    if (self.scrollEnabled) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    if (self.showIndicatorLineView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CGPoint center = CGPointMake(cell.center.x , cell.height - IndicatorLineH);
        if (self.is_first) {
            self.is_first = NO;
            self.indicatroLineView.center = center;
        }else{
            __weak typeof(self) weakSelf=self;
            [UIView animateWithDuration:0.25 animations:^{
                if (weakSelf.indicatorLineAutoWidth) {
                    weakSelf.indicatroLineView.width = cell.width * 0.8;
                }
                weakSelf.indicatroLineView.center = center;
            }];
        }
    }
}

#pragma mark ====== Functions =======
-(void)setScrollToIndex:(NSInteger)scrollToIndex{
    current_selected_index = scrollToIndex;
    [self layoutIfNeeded];
    if (_index_arr.count > 0) {
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:scrollToIndex inSection:0]];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:scrollToIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

-(NSInteger)current_index{
    return current_selected_index;
}

-(void)setIndex_arr:(NSArray *)index_arr{
    _index_arr = index_arr;
    [self.collectionView reloadData];
    if (_index_arr.count > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    }
}

-(void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
    [self.collectionView reloadData];
}

// indicatroLineView
-(UIView *)indicatroLineView{
    if (_indicatroLineView==nil) {
        _indicatroLineView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - IndicatorLineH, _indicatorLineWidth, IndicatorLineH)];
        _indicatroLineView.backgroundColor = [UIColor greenColor];
        _indicatroLineView.layer.cornerRadius=2;
        _indicatroLineView.clipsToBounds=YES;
    }
    return _indicatroLineView;
}

@end
