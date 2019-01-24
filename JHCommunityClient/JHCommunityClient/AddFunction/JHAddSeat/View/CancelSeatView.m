//
//  CancelSeatView.m
//  JHCommunityClient
//
//  Created by jianghu3 on 16/9/22.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "CancelSeatView.h"
#import "AppDelegate.h"
#import "SeatCancelCell.h"

@interface CancelSeatView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *centerView;
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,copy)NSString *cancelStr;
@end

@implementation CancelSeatView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    control.alpha=0;
    self.control=control;
    
    UIView *centerView=[UIView new];
    [self.control addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset=0;
        make.centerY.offset=0;
        make.width.offset=self.width;
        //        make.height.offset=self.height;
    }];
    centerView.backgroundColor=[UIColor whiteColor];
    centerView.layer.cornerRadius=4;
    centerView.clipsToBounds=YES;
    centerView.alpha=0;
    self.centerView=centerView;
    
    UILabel *titleLab=[UILabel new];
    [centerView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.width.offset=self.width;
        make.height.offset=40;
    }];
    titleLab.backgroundColor=HEX(@"f5f5f5", 1.0);
    titleLab.text=@"请选择取消的理由";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=HEX(@"333333", 1.0);
    titleLab.font=FONT(14);
    
    UICollectionViewFlowLayout * flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,40,self.width,self.height) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor=[UIColor whiteColor];
    [collectionView registerClass:[SeatCancelCell class] forCellWithReuseIdentifier:@"SeatCancelCell"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [centerView addSubview:collectionView];
    self.collectionView=collectionView;

    UIView *lineView=[UIView new];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(collectionView.mas_bottom).offset=0;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    for (NSInteger i=0; i<2; i++) {
        
        UIButton *btn=[UIButton new];
        [centerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset=self.width/2.0*i;
            make.top.equalTo(lineView.mas_bottom).offset=0.5;
            make.width.offset=self.width/2.0;
            make.height.offset=40;
        }];
        btn.titleLabel.font=FONT(14);
        if (i==0) {
            [btn setTitle:NSLocalizedString(@"放弃取消", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
        }else{
            [btn setTitle:NSLocalizedString(@"确定取消", nil) forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"ff3300", 1.0) forState:UIControlStateNormal];
        }
        btn.tag=100+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *vLineView=[UIView new];
    [centerView addSubview:vLineView];
    [vLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=self.width/2.0-0.25;
        make.top.equalTo(collectionView.mas_bottom).offset=0;
        make.width.offset=0.5;
        make.bottom.offset=0;
    }];
    vLineView.backgroundColor=LINE_COLOR;
    
    [centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_bottom).offset=40;
    }];
}

//点击确定或取消
-(void)click:(UIButton *)btn{
    if (btn.tag-100==1) {//确定
        if (self.cancelStr.length ==0 ) return;
        if (self.clickSure)  self.clickSure(self.cancelStr);
    }
    [self hidden];
    
}

//消失
-(void)hidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.control.alpha=0;
        self.centerView.alpha=0;
    }];
    self.cancelStr=@"";
    [self removeFromSuperview];
    
}

-(void)show{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.control.alpha=1;
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.centerView.alpha=1;
    }];
    
}

-(void)setCancelArr:(NSArray *)cancelArr{
    _cancelArr=cancelArr;
    int count=(int)cancelArr.count/2 +(int)cancelArr.count%2;
    self.collectionView.height=count*36+10*(count+1);
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cancelArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeatCancelCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SeatCancelCell" forIndexPath:indexPath];
    cell.titleStr=self.cancelArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.cancelStr=self.cancelArr[indexPath.row];
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.width-30)/2, 36);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
