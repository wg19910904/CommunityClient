//
//  JHSuperMarketListCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/2.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSuperMarketListCell.h"
#import <UIImageView+WebCache.h>

@implementation JHSuperMarketListCell
{
    //cell的宽 高
    CGFloat width;
    //子视图
    UIImageView *logoIV;
    UILabel *titleLabel;
    UILabel *businessHourLabel;
    UILabel *saleNumLabel;
    UIView *typeView;
    UILabel *distanceLabel;
    //辅助控件
    UIImageView *timeIV;
    UIImageView *distanceIV;
    UIView *lineView;
    //
    UILabel *type1;
    UILabel *restL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        width = WIDTH;
        self.frame = FRAME(0, 0, width, 80);
        //添加子视图
        [self addSubviews];
    }
    return self;
}
#pragma mark - 添加子视图
- (void)addSubviews
{
    //添加商品图片,标签,价格,数量等
    logoIV = [UIImageView new];
    titleLabel = [UILabel new];
    timeIV = [UIImageView new];
    businessHourLabel = [UILabel new];
    lineView = [UIView new];
    saleNumLabel = [UILabel new];
    distanceIV = [UIImageView new];
    distanceLabel = [UILabel new];
    typeView = [UIView new];
    [self addSubview:logoIV];
    [self addSubview:titleLabel];
    [self addSubview:timeIV];
    [self addSubview:businessHourLabel];
    [self addSubview:lineView];
    [self addSubview:saleNumLabel];
    [self addSubview:distanceIV];
    [self addSubview:distanceLabel];
    [self addSubview:typeView];
    
    restL = [UILabel new];
    restL.frame = FRAME(0, 35, 55, 20);
    restL.backgroundColor = HEX(@"000000",0.6f);
    restL.textColor = [UIColor whiteColor];
    restL.font = [UIFont boldSystemFontOfSize:12];
    restL.text = NSLocalizedString(@"休息中", nil);
    restL.textAlignment = NSTextAlignmentCenter;
    [logoIV addSubview:restL];
    
    //添加下边线
    UIView *lineView_bottom = [[UIView alloc] initWithFrame:FRAME(0, 79.5, WIDTH, 0.5)];
    lineView_bottom.backgroundColor = LINE_COLOR;
    [self addSubview:lineView_bottom];
}
#pragma mark - 设置数据及设置控件frame
- (void)setDataModel:(JHWaimaiShopItemModel *)dataModel
{
    _dataModel = dataModel;
    //设置控件内容及frame
    logoIV.frame = FRAME(5, 12.5, 55, 55);
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.logo]];
    [logoIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shopDefault")];
    //添加店铺标题
    titleLabel.frame = FRAME(70, 5, WIDTH - 80, 20);
    titleLabel.text = dataModel.title;
    titleLabel.font = FONT(15);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    timeIV.frame = FRAME(70, 27.5, 13, 13);
    timeIV.image = IMAGE(@"time");
    businessHourLabel.frame = FRAME(90, 25,80, 20);
    businessHourLabel.text = [NSString stringWithFormat:@"%@-%@",dataModel.yy_stime,dataModel.yy_ltime];
    businessHourLabel.font = FONT(11);
    businessHourLabel.textAlignment = NSTextAlignmentLeft;
    businessHourLabel.textColor = HEX(@"999999", 1.0f);
    
    lineView.frame = FRAME(165, 28.5, 1.5,15);
    lineView.backgroundColor = LINE_COLOR;
    
    saleNumLabel.frame = FRAME(175, 25, 80, 20);
    saleNumLabel.font = FONT(11);
    saleNumLabel.textColor = HEX(@"999999", 1.0f);
    saleNumLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"月售", nil),dataModel.orders];
    
    distanceIV.frame = FRAME(width - 75, 28.5, 8, 11);
    distanceIV.image = IMAGE(@"zuobaio2");
    
    distanceLabel.frame = FRAME(width - 62,28,57, 12);
    distanceLabel.text = dataModel.juli_label;
    distanceLabel.font = FONT(12);
    distanceLabel.textColor = HEX(@"999999", 1.0f);
    
    typeView.frame = FRAME(70, 48, width - 80, 13);
    for (__strong UIView *view in typeView.subviews) {
        [view removeFromSuperview];
        view = nil;
    }
    type1 = [[UILabel alloc] initWithFrame:FRAME(0, 0, 50, 18)];
    type1.backgroundColor = HEX(@"ff6269", 1.0f);
    type1.text = dataModel.cate_title;
    type1.frame = FRAME(0, 0, dataModel.cate_title.length * 11+6, 18);
    type1.font = FONT(12);
    type1.textColor = [UIColor whiteColor];
    type1.textAlignment = NSTextAlignmentCenter;
    type1.layer.cornerRadius = 2;
    type1.layer.masksToBounds = YES;
    [typeView addSubview:type1];
    //判断是否显示打烊
    [self judgeRest:dataModel.yysj_status];
}
- (void)judgeRest:(NSString *)status
{
    if ([status isEqualToString:@"1"]) {
        //营业
        restL.hidden = YES;
    }else{
        //休息中
        restL.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    type1.backgroundColor = HEX(@"ff6269", 1.0f);
    restL.backgroundColor = HEX(@"000000",0.6f);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    type1.backgroundColor = HEX(@"ff6269", 1.0f);
    restL.backgroundColor = HEX(@"000000",0.6f);
}
@end
