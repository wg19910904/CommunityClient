//
//  JHTuanGouDetailCellOne.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouDetailCellOne.h"
#import <UIImageView+WebCache.h>
@implementation JHTuanGouDetailCellOne
{
    UIScrollView *top_scrollView;
    UIImageView *iv1;
    UIImageView *iv2;
    UIImageView *iv3;
    UIView *backView;
    UILabel *titleLabel1;
    UILabel *infolabel;
    UIPageControl *pageControl;
    UILabel *priceLabel;
    UILabel *storePriceLabel;
    UILabel *numLabel;
    UIButton *_orderBtn;
    UIView *lineView;
    UILabel *shopInfoTitleLabel;
    UILabel *titleLabel2;
    UILabel *addressLabel;
    UIButton *_phoneBtn;
    UILabel *distanceLabel;
    UIView *lineView2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加控件
        [self createSubviews];
    }
    return self;
}
#pragma mark - 创建子控件
- (void)createSubviews
{
    top_scrollView = [UIScrollView new];
    top_scrollView.delegate = self;
    iv1 = [UIImageView new];
    backView = [UIView new];
    titleLabel1 = [UILabel new];
    infolabel = [UILabel new];
    priceLabel = [UILabel new];
    storePriceLabel = [UILabel new];
    numLabel = [UILabel new];
    _orderBtn = [UIButton new];
    lineView = [UIView new];
    shopInfoTitleLabel = [UILabel new];
    titleLabel2 = [UILabel new];
    addressLabel = [UILabel new];
    _phoneBtn = [UIButton new];
    distanceLabel = [UILabel new];
    lineView2 = [UIView new];
    
    [self addSubview:top_scrollView];
    [top_scrollView addSubview:iv1];
    [self addSubview:backView];
    [backView addSubview:titleLabel1];
    [backView addSubview:infolabel];
    [backView addSubview:pageControl];
    [self addSubview:priceLabel];
    [self addSubview:storePriceLabel];
    [self addSubview:numLabel];
    [self addSubview:_orderBtn];
    [self addSubview:lineView];
    [self addSubview:shopInfoTitleLabel];
    [self addSubview:titleLabel2];
    [self addSubview:addressLabel];
    [self addSubview:_phoneBtn];
    [self addSubview:distanceLabel];
    [self addSubview:lineView2];
}
#pragma mark - 外部数据传入时,设置各个控件
- (void)setDataModel:(JHTuanGouDetialCellOneModel *)dataModel
{
    _dataModel = dataModel;
    CGFloat height = 160*WIDTH/320;
    //设置控件
    top_scrollView.frame = FRAME(0, 0, WIDTH, height);
    top_scrollView.contentSize = CGSizeMake(WIDTH, 0);
    iv1.frame = FRAME(0, 0, WIDTH, height);
    backView.frame = FRAME(0, height - 60, WIDTH, 60);
    titleLabel1.frame = FRAME(10, 0, WIDTH - 20, 30);
    infolabel.frame = FRAME(10,30, WIDTH - 20, 30);
    pageControl.frame = FRAME(0, 22.5, 80, 15);
    pageControl.center = CGPointMake(self.center.x, pageControl.center.y);
    priceLabel.frame = FRAME(10,height+5, 90, 30);
    storePriceLabel.frame = FRAME(100,height+5, 120, 30);
    numLabel.frame = FRAME(10, height + 30, 150, 30);
    _orderBtn.frame = FRAME(WIDTH-100, height+10, 90, 40);
    lineView.frame = FRAME(0,height+60, WIDTH, 0.5);
    shopInfoTitleLabel.frame = FRAME(10,height+60, WIDTH - 20, 25);
    titleLabel2.frame = FRAME(10,height+85, WIDTH - 70, 25);
    addressLabel.frame = FRAME(10,height+110, WIDTH - 70, 25);
    _phoneBtn.frame = FRAME(WIDTH - 40, height+75, 30, 30);
    distanceLabel.frame = FRAME(WIDTH - 80,height+105, 70, 15);
    lineView2.frame = FRAME(0,height+134.5, WIDTH, 0.5);
    top_scrollView.pagingEnabled = YES;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.photo]];
    [iv1 sd_setImageWithURL:url placeholderImage:IMAGE(@"tgtopdeafault")];
    iv1.contentMode = UIViewContentModeScaleAspectFill;
    iv1.clipsToBounds = YES;
    backView.backgroundColor = HEX(@"000000", 0.3);
    titleLabel1.text = dataModel.title;
    titleLabel1.font = FONT(16);
    titleLabel1.textColor = [UIColor whiteColor];
    infolabel.text = dataModel.desc;
    infolabel.font = FONT(12);
    infolabel.textColor = [UIColor whiteColor];
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorTintColor = THEME_COLOR;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPage = 0;
    priceLabel.textColor = SPECIAL_COLOR;
    priceLabel.text = [NSString stringWithFormat:@"%@%g",NSLocalizedString(@"¥", nil),[dataModel.price floatValue]];
    priceLabel.font = FONT(14);
    
    storePriceLabel.text = [NSString stringWithFormat:@"%@%g",NSLocalizedString(@"门市价: ¥", nil),[dataModel.market_price floatValue]];
    storePriceLabel.font = FONT(14);
    storePriceLabel.textColor = HEX(@"333333", 1.0f);
    
    numLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"已售数量:", nil),[dataModel.sales integerValue] + [dataModel.virtual_sales integerValue]];
    numLabel.font = FONT(12);
    numLabel.textColor = HEX(@"333333", 1.0f);
    
    lineView.backgroundColor = LINE_COLOR;
    
    shopInfoTitleLabel.text = NSLocalizedString(@"商家信息", nil);
    shopInfoTitleLabel.textColor = HEX(@"333333", 1.0f);
    shopInfoTitleLabel.font = FONT(14);
    
    titleLabel2.text = dataModel.shop_title;
    titleLabel2.font = FONT(14);
    titleLabel2.textColor = HEX(@"333333", 1.0f);
    
    addressLabel.text = dataModel.addr;
    addressLabel.font = FONT(13);
    addressLabel.textColor = HEX(@"999999", 1.0f);
    
    [_phoneBtn setImage:IMAGE(@"tg_phone") forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    distanceLabel.text = dataModel.juli_label;
    distanceLabel.textColor = HEX(@"999999", 1.0f);
    distanceLabel.font = FONT(11);
    distanceLabel.textAlignment = NSTextAlignmentRight;
    
    lineView2.backgroundColor = LINE_COLOR;
    [self handleOrderBtn:dataModel.tuan_status];
}
#pragma mark - 这是点击打电话的按钮调用的方法
-(void)phoneBtnClick:(UIButton*)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:self.dataModel.mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确定
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.dataModel.mobile]]];
    }]];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 处理按钮状态
- (void)handleOrderBtn:(NSString *)statusStr
{
    CGFloat height = 160*WIDTH/320;
    if ([statusStr isEqualToString:@"on_sales"]) { //有效期内且上架
        _orderBtn.userInteractionEnabled = YES;
        _orderBtn.frame = FRAME(WIDTH-100, height+10, 90, 40);
        [_orderBtn setTitle:NSLocalizedString(@"立即抢购", nil) forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:SPECIAL_COLOR forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:SPECIAL_COLOR_DOWN forState:UIControlStateHighlighted];
        _orderBtn.titleLabel.font = FONT(16);
        _orderBtn.layer.cornerRadius = 3;
        _orderBtn.layer.masksToBounds = YES;
        [_orderBtn setImage:IMAGE(@"") forState:(UIControlStateNormal)];
        
    }else if([statusStr isEqualToString:@"expired"]){//过期
        _orderBtn.userInteractionEnabled = NO;
        _orderBtn.frame = FRAME(WIDTH - 70, height+7.5,45, 45);
        [_orderBtn setTitle:@"" forState:(UIControlStateNormal)];
        _orderBtn.layer.cornerRadius = 22.5;
        _orderBtn.layer.masksToBounds = YES;
        [_orderBtn setImage:IMAGE(@"tuan_late") forState:(UIControlStateNormal)];
    }else if([statusStr isEqualToString:@"off_sales"]){//下架
        _orderBtn.userInteractionEnabled = NO;
        _orderBtn.frame = FRAME(WIDTH - 70, height+7.5,45, 45);
        [_orderBtn setTitle:@"" forState:(UIControlStateNormal)];
        _orderBtn.layer.cornerRadius = 22.5;
        _orderBtn.layer.masksToBounds = YES;
        [_orderBtn setImage:IMAGE(@"xiajia") forState:(UIControlStateNormal)];
        
    }
}
//#pragma mark - scrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offset_x = scrollView.contentOffset.x;
//    NSInteger index =  offset_x/WIDTH;
//    pageControl.currentPage = index;
//}
@end
