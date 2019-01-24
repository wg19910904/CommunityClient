//
//  JHCommunityAllCateVC.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHCommunityAllCateVC.h"
#import "UIImageView+NetStatus.h"
#import "CustomView.h"
#import "JHCommunityAllCateCell.h"
@interface JHCommunityAllCateVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_allCateCollection;
    UICollectionViewFlowLayout *_flowLayout;
}
@end

@implementation JHCommunityAllCateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"全部", nil);
    [self cretaeAllCateTableView];
}
#pragma mark--===创建表视图
- (void)cretaeAllCateTableView{
    if(_allCateCollection == nil){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _allCateCollection = [[UICollectionView alloc] initWithFrame:FRAME(0, NAVI_HEIGHT, WIDTH, HEIGHT - NAVI_HEIGHT) collectionViewLayout:_flowLayout];
        [_allCateCollection registerClass:[JHCommunityAllCateCell class] forCellWithReuseIdentifier:@"communityCell"];
        [_allCateCollection registerClass:[CustomView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"communityHead"];
        _allCateCollection.delegate = self;
        _allCateCollection.dataSource = self;
        _allCateCollection.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        _allCateCollection.backgroundView = view;
        [self.view addSubview:_allCateCollection];
    }else{
        [_allCateCollection reloadData];
    }
}
#pragma mark--==UICollectionDelegate DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHCommunityAllCateCell *cell = [_allCateCollection dequeueReusableCellWithReuseIdentifier:@"communityCell" forIndexPath:indexPath];
    return cell;
}
//每个cell的高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH-20)/4, (WIDTH-20)/4 + 20);
}
//设置Insets
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0,10);
}
//点击每个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
//组头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CustomView *view;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        view = [_allCateCollection dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"communityHead" forIndexPath:indexPath];
    }
    view.backgroundColor = BACK_COLOR;
    UIImageView *img = nil;
    if(img == nil){
        img = [[UIImageView alloc] init];
    }
    img.frame = FRAME(10, 5, 20, 20);
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    img.image = IMAGE(@"pay_4");
    //    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:[NSString stringWithFormat:@"%@",[_dataArray[indexPath.section] icon]]]];
    // [img sd_image:url plimage:IMAGE(@"house&maintainonecategory")];
    [view addSubview:img];
    if(view.title == nil){
        view.title = [[UILabel alloc] init];
    }
    view.title.frame =  FRAME(40, 0, WIDTH - 40, 30);
    view.title.font = FONT(14);
    view.title.textColor = HEX(@"666666", 1.0f);
    //view.title.text = [_dataArray[indexPath.section] title];
    view.title.text = NSLocalizedString(@"小区", nil);
    view.title.backgroundColor = BACK_COLOR;
    [view addSubview:view.title];
    UIView *thread1 = nil;
    if(thread1 == nil){
        thread1 = [[UIView alloc] init];
    }
    thread1.frame = FRAME(0, 0, WIDTH, 0.5);
    thread1.backgroundColor = LINE_COLOR;
    if(indexPath.section != 0){
        [view addSubview:thread1];
    }
    UIView *thread2 = nil;
    if(thread2 == nil){
        thread2 = [[UIView alloc] init];
    }
    thread2.frame = FRAME(0, 29.5, WIDTH, 0.5);
    thread2.backgroundColor = LINE_COLOR;
    [view addSubview:thread2];
    return view;
}
//组头尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 30);
}
@end
