//
//  HistorySearchView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/4/8.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "HistorySearchView.h"
#import <YFCollectionViewAutoFlowLayout.h>
#import "YFCollectionReusableView.h"
 
#import "SearchCollectionViewCell.h"

@interface HistorySearchView ()<UICollectionViewDelegate,UICollectionViewDataSource,YFCollectionViewAutoFlowLayoutDelegate>

@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *hotDataSource;
@property(nonatomic,strong)NSMutableArray *historyDataSource;

@end


@implementation HistorySearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
 
    YFCollectionViewAutoFlowLayout * flowLayout=[[YFCollectionViewAutoFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.delegate = self;
    flowLayout.interSpace = 10;
    flowLayout.itemSizeType = ItemSizeEqualHeight;
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = self.backgroundColor;
    [collectionView registerClass:[YFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"YFCollectionReusableView"];
    [collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];
    self.collectionView =collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.bottom.offset=0;
    }];
    
    [self getData];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView itemSizeForIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"";
    if (indexPath.section == 0) {
        if (self.hotDataSource.count == 0) {
            str = self.historyDataSource[indexPath.item];
        }else{
            str = self.hotDataSource[indexPath.item];
        }
    }else{
        str = self.historyDataSource[indexPath.item];
    }
    CGSize size = getSize(str, 20, 14);
    return CGSizeMake(size.width+20, 20);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.hotDataSource.count == 0 && self.historyDataSource.count== 0) {
        return 0;
    }
    if (self.hotDataSource.count == 0 || self.historyDataSource.count== 0) {
        return 1;
    }
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.hotDataSource.count == 0) {
             return self.historyDataSource.count;
        }
         return self.hotDataSource.count;
    }else{
        return self.historyDataSource.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YFCollectionViewAutoFlowLayoutCell" forIndexPath:indexPath];
    
    NSString *title = @"";
    if (indexPath.section == 0) {
        title =  self.hotDataSource.count == 0 ? self.historyDataSource[indexPath.item] :  self.hotDataSource[indexPath.item];
    }else{
         title = self.historyDataSource[indexPath.item];
    }
    
    [cell reloadCellWith:title];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"";
    if (indexPath.section == 0) {
        title =  self.hotDataSource.count == 0 ? self.historyDataSource[indexPath.item] :  self.hotDataSource[indexPath.item];
    }else{
        title = self.historyDataSource[indexPath.item];
    }
    if (self.clickTitle) {
        self.clickTitle(title);
    }
}

#pragma mark - 返回头视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    YFCollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YFCollectionReusableView" forIndexPath:indexPath];
    NSString *text;
    if (indexPath.section==0) {
        text = self.hotDataSource.count == 0 ? NSLocalizedString(@"历史搜索", nil) :  NSLocalizedString(@"热门搜索", nil);
    }else{
        text = NSLocalizedString(@"历史搜索", nil);
    }
    header.titleStr = text;
    header.hidden_delete = ![text isEqualToString:NSLocalizedString(@"历史搜索", nil)];
     __weak typeof(self) weakSelf=self;
    header.deleteHistory = ^(){
        [weakSelf clearSearchHistory];
    };
    return header;
}

#pragma  mark - 设置头视图的size
-(CGSize)collectionView:(UICollectionView *)collectionView sectionHeadSizeForSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 20);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 20);
//}

-(NSMutableArray *)hotDataSource{
    if (_hotDataSource==nil) {
        _hotDataSource=[[NSMutableArray alloc] init];
    }
    return _hotDataSource;
}

-(NSMutableArray *)historyDataSource{
    if (_historyDataSource==nil) {
        _historyDataSource=[[NSMutableArray alloc] init];
    }
    return _historyDataSource;
}

-(void)getData{
    
    [self.historyDataSource removeAllObjects];
    NSArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"WaiMaiHistorySearch"];
    if (arr != nil) {
        [self.historyDataSource addObjectsFromArray:arr];
    }
    SHOW_HUD_INVIEW(self)
    [HttpTool postWithAPI:@"client/v2/waimai/shop/hotwaimai" withParams:@{} success:^(id json) {
        HIDE_HUD_FOR_VIEW(self)
        NSLog(@"热门搜索 =======  %@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self.hotDataSource removeAllObjects];
            [self.hotDataSource addObjectsFromArray:json[@"data"][@"hotwaimai"]];
        }
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        HIDE_HUD_FOR_VIEW(self)
    }];
    
}

-(void)searchHistoryAddStr:(NSString *)str{
    
    if ([self.historyDataSource containsObject:str]) {
        [self.historyDataSource removeObject:str];
    }

    [self.historyDataSource insertObject:str atIndex:0];
    
    if (self.historyDataSource.count > 10) {
        [self.historyDataSource removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDataSource forKey:@"WaiMaiHistorySearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collectionView reloadData];
}

-(void)clearSearchHistory{
    [self.historyDataSource removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyDataSource forKey:@"WaiMaiHistorySearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.collectionView reloadData];
}

@end
