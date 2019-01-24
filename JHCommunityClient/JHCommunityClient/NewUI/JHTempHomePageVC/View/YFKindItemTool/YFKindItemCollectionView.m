//
//  KindItemCollectionView.m
//  LayoutTest
//
//  Created by ios_yangfei on 16/12/2.
//  Copyright © 2016年 jianghu3. All rights reserved.
//

#import "YFKindItemCollectionView.h"
#import <YFCollectionViewAutoFlowLayout.h>
#import "KindItemCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface YFKindItemCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,YFCollectionViewAutoFlowLayoutDelegate>{
    BOOL currentTool;
    
}
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)UIPageControl *pageControl;


@end

@implementation YFKindItemCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame isTool:(BOOL)isTool{
    self = [super initWithFrame:frame];
    if (self) {
        currentTool = isTool;
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    YFCollectionViewAutoFlowLayout * layout = [[YFCollectionViewAutoFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.interSpace = 0; // 每个item 的间隔
    layout.numberOfLines = 2; // 列数;
    layout.numberOfItemsInLine = currentTool?4:5;
    layout.itemSizeType = ItemSizeEqualAll;
    layout.delegate = self;

   UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.frame.size.height) collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[KindItemCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
     self.collectionView = collectionView;
}

#pragma mark ====== UICollectionViewDataSource,UICollectionViewDelegate =======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KindItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.isTool = currentTool;
    [cell reloadCellWithDic:self.dataSource[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickKindItem) {//点击事件的回调
        self.clickKindItem(indexPath.item);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVie{
    if (self.myBlock) {
        self.myBlock(scrollVie.contentOffset.x);
    }
    NSInteger page = scrollVie.contentOffset.x/self.bounds.size.width;
    [_pageControl setCurrentPage:page];
}
#pragma mark ======YFCollectionViewLayoutDelegate=======
-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    CGFloat width =  self.bounds.size.width/self.colOrLineItems;
    if (currentTool) {
        return CGSizeMake(width, 90);
    }
    return CGSizeMake(width, WIDTH/4);
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    if (dataSource.count <=currentTool?8:10&& _pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }

    [self pageControl];
}
#pragma mark -- 当按钮超过八个时需要pageControl
-(UIPageControl *)pageControl{
    if (!_pageControl && _dataSource.count >(currentTool?8:10)) {
        _pageControl = [[UIPageControl alloc]initWithFrame:FRAME(0, self.frame.size.height -20, self.bounds.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor = THEME_COLOR;
        _pageControl.enabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.backgroundColor = [UIColor whiteColor];
        if (self.dataSource.count%(currentTool?8:10)== 0) {
            _pageControl.numberOfPages = _dataSource.count/(currentTool?8:10);
        }else{
            _pageControl.numberOfPages = _dataSource.count/(currentTool?8:10)+1;
        }
        [self addSubview:_pageControl];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (void)setHeight:(CGFloat)height{
    self.frame = FRAME(0, 0, self.bounds.size.width, height);
    self.collectionView.height = height;
}
@end
