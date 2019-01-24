//
//  JHPhotoAllVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPhotoAllVC.h"
#import "JHPhotoCollectionCell.h"
 
#import "DisplayImageInView.h"
@interface JHPhotoAllVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation JHPhotoAllVC
{
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self loadNewData];
    
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"client/shop/album/item"
               withParams:@{@"shop_id":_shop_id,
                            @"type":@"0"}
                  success:^(id json) {
                      NSLog(@"%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          dataArray = json[@"data"][@"items"];
                          [self createMainCollection];
                      }
                      HIDE_HUD
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                      HIDE_HUD
                  }];
}
#pragma mark - 初始化表视图
- (void)createMainCollection
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((WIDTH - 15)/2,(WIDTH - 15)/2/29*22 );
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(5, 5 , WIDTH - 10, HEIGHT - (NAVI_HEIGHT+40)) collectionViewLayout:layout];
        //注册Cell
        [_collectionView registerClass:[JHPhotoCollectionCell class] forCellWithReuseIdentifier:@"JHPhotoCollectionCellID1"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
}
#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHPhotoCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"JHPhotoCollectionCellID1" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dataDic = dataArray[indexPath.row];
    cell.titleLabel.text = NSLocalizedString(@"全部", nil);
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSMutableArray *urlArr = @[].mutableCopy;
    for (NSDictionary *dic in dataArray) {
        [urlArr addObject:[IMAGEADDRESS stringByAppendingString:dic[@"photo"]]];
    }
    __block DisplayImageInView *imgView = [DisplayImageInView new];
    [imgView showInViewWithImageUrlArray:urlArr withIndex:index+1 withBlock:^{
        
        [imgView removeFromSuperview];
        imgView = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
