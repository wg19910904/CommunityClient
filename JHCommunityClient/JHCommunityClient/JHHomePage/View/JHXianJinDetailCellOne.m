//
//  JHTuanGouDetailCellOne.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHXianJinDetailCellOne.h"

@implementation JHXianJinDetailCellOne
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
    iv2 = [UIImageView new];
    iv3 = [UIImageView new];
    backView = [UIView new];
    titleLabel1 = [UILabel new];
    infolabel = [UILabel new];
    pageControl = [UIPageControl new];
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
    [top_scrollView addSubview:iv2];
    [top_scrollView addSubview:iv3];
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
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    CGFloat height = 160*WIDTH/320;
    //设置控件
    top_scrollView.frame = FRAME(0, 0, WIDTH, height);
    top_scrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
    iv1.frame = FRAME(0, 0, WIDTH, height);
    iv2.frame = FRAME(WIDTH, 0, WIDTH, height);
    iv3.frame = FRAME(WIDTH * 2, 0, WIDTH, height);
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
    
    iv1.image = IMAGE(@"5");
    iv1.contentMode = UIViewContentModeScaleAspectFill;
    iv1.clipsToBounds = YES;
    iv2.image = IMAGE(@"5");
    iv2.contentMode = UIViewContentModeScaleAspectFill;
    iv1.clipsToBounds = YES;
    iv3.image = IMAGE(@"5");
    iv3.contentMode = UIViewContentModeScaleAspectFill;
    iv1.clipsToBounds = YES;
    
    backView.backgroundColor = HEX(@"000000", 0.3);
    titleLabel1.text = NSLocalizedString(@"花千骨(华润五彩城店)", nil);
    titleLabel1.font = FONT(16);
    titleLabel1.textColor = [UIColor whiteColor];
    
    infolabel.text = NSLocalizedString(@"50元代金券,可叠加,免预约", nil);
    infolabel.font = FONT(12);
    infolabel.textColor = [UIColor whiteColor];
    
    pageControl.numberOfPages = 3;
    pageControl.currentPageIndicatorTintColor = THEME_COLOR;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPage = 0;
    
    priceLabel.textColor = SPECIAL_COLOR;
    priceLabel.text = @"¥499.99";
    priceLabel.font = FONT(14);
    
    storePriceLabel.text = NSLocalizedString(@"门市价: ¥599.99", nil);
    storePriceLabel.font = FONT(14);
    storePriceLabel.textColor = HEX(@"333333", 1.0f);
    
    numLabel.text = NSLocalizedString(@"已售出320000", nil);
    numLabel.font = FONT(12);
    numLabel.textColor = HEX(@"333333", 1.0f);
    
    [_orderBtn setTitle:NSLocalizedString(@"立即抢购", nil) forState:UIControlStateNormal];
    [_orderBtn setBackgroundColor:SPECIAL_COLOR forState:UIControlStateNormal];
        [_orderBtn setBackgroundColor:SPECIAL_COLOR_DOWN forState:UIControlStateHighlighted];
    _orderBtn.titleLabel.font = FONT(14);
    _orderBtn.layer.cornerRadius = 3;
    _orderBtn.layer.masksToBounds = YES;
    
    lineView.backgroundColor = LINE_COLOR;
    
    shopInfoTitleLabel.text = NSLocalizedString(@"商家信息", nil);
    shopInfoTitleLabel.textColor = HEX(@"333333", 1.0f);
    shopInfoTitleLabel.font = FONT(14);
    
    titleLabel2.text = NSLocalizedString(@"花千骨(华润五彩城店)", nil);
    titleLabel2.font = FONT(14);
    titleLabel2.textColor = HEX(@"333333", 1.0f);
    
    addressLabel.text = NSLocalizedString(@"包河区望江西路黄山花园6栋504", nil);
    addressLabel.font = FONT(13);
    addressLabel.textColor = HEX(@"999999", 1.0f);
    
    [_phoneBtn setImage:IMAGE(@"tg_phone") forState:UIControlStateNormal];
    distanceLabel.text = @"0.5KM";
    distanceLabel.textColor = HEX(@"999999", 1.0f);
    distanceLabel.font = FONT(11);
    distanceLabel.textAlignment = NSTextAlignmentRight;
    
    lineView2.backgroundColor = LINE_COLOR;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_x = scrollView.contentOffset.x;
    NSInteger index =  offset_x/WIDTH;
    pageControl.currentPage = index;
}
@end
