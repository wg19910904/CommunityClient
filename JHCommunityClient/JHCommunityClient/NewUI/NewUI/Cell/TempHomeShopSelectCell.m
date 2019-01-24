//
//  TempHomeShopSelectCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeShopSelectCell.h"
#import <UIImageView+WebCache.h>
#import "TempHomeShopSelectCollectionViewCell.h"

@interface TempHomeShopSelectCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *imgVArr;//保存图片的
    NSMutableArray *dataArr;
}

@property(nonatomic,strong)UICollectionView *mainCollectionView;


@end
@implementation TempHomeShopSelectCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imgVArr = @[].mutableCopy;
        dataArr = @[].mutableCopy;
        [self creatUI];
        [self mainCollectionView];
  
    }
    return self;
}
-(void)creatUI{
    UILabel *titleL =[[UILabel alloc]init];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 10;
        make.left.offset = 10;
        make.width.offset = 100;
        make.height.offset = 15;
    }];
    titleL.text = NSLocalizedString(@"精选商家",nil);
    titleL.font =FONT(14);
    titleL.textColor = RGBA(51, 51, 51, 1.0);
    
    
    _moreBtn = [[UIButton alloc]init];
    [self addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset =10;
        make.right.offset = -10;
        make.width.offset =100;
        make.height.offset = 15;
    }];
    [_moreBtn setTitle:NSLocalizedString(@"更多商家>>",nil) forState:0];
    _moreBtn.titleLabel.font = FONT(14);
    _moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_moreBtn setTitleColor:[UIColor redColor] forState:0];
   
}
-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0.01;
        layout.minimumInteritemSpacing = 0.01;
       
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 35*WIDTH/375, WIDTH, 230*WIDTH/375) collectionViewLayout:layout];
         _mainCollectionView.backgroundColor = [UIColor clearColor];
//        layout.itemSize = CGSizeMake(109, 128);
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        [self addSubview:_mainCollectionView];
        
        [_mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset =0;
            make.top.offset = 35*WIDTH/375;
        }];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        [_mainCollectionView registerClass:[TempHomeShopSelectCollectionViewCell class] forCellWithReuseIdentifier:@"TempHomeShopSelectCollectionViewCell"];     
    }
 
    return _mainCollectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH/3, self.height - 35*WIDTH/375);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
    
    NSLog(@"点击了%ld",indexPath.row);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TempHomeShopSelectCollectionViewCell *cell = (TempHomeShopSelectCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TempHomeShopSelectCollectionViewCell" forIndexPath:indexPath];
    
    cell.model= _array[indexPath.row];

    
    return cell;
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.01;
}
-(void)setArray:(NSArray *)array{
    _array = array;
    
    [_mainCollectionView reloadData];
}



@end
