//
//  JHHomePageCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/26.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHomePageCell.h"
#import "StarView.h"
#import <UIImageView+WebCache.h>
#import "GaoDe_Convert_BaiDu.h"
#import <CoreLocation/CoreLocation.h>
#import "JHShareModel.h"
#import "NSObject+CGSize.h"
#import "XHStarView.h"
@implementation JHHomePageCell
{
    //左侧图片
    UIImageView *leftIV;
    //店铺名称
    UILabel *titleLabel;
    //店铺评分
    XHStarView *starView;
    //店铺类型
    UILabel *typeLabel;
    //店铺优惠view
    UIView *youhuiView;
    //店铺消费水平
    UILabel *costLabel;
    //店铺距离
    UIView *distanceView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = FRAME(0, 0, WIDTH, 70);
        //添加子控件
        [self addsubViews];
    }
    return self;
}
- (void)addsubViews
{
    leftIV = [UIImageView new];
    titleLabel = [UILabel new];
    costLabel = [UILabel new];
    typeLabel = [UILabel new];
    [self addSubview:costLabel];
    [self addSubview:typeLabel];
    //添加cell上分割线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = HEX(@"e6e6e6", 1.0);
    
//    //添加下分割线
//    CALayer *line = [CALayer layer];
//    line.frame = FRAME(0, 69.5, WIDTH, 0.5);
//    line.backgroundColor = HEX(@"e6e6e6", 1.0).CGColor;
//    [self.layer addSublayer:line];
    [self addSubview:lineView];
    [self addSubview:leftIV];
    [self addSubview:titleLabel];
}
- (void)setDataModel:(JHHomePageShopItemModel *)dataModel
{
    _dataModel = dataModel;
    //添加左侧图片
    leftIV.frame = FRAME(10, 10, 80, 80);
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.logo ? dataModel.logo : @""]];
    [leftIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shopDefault")];
    
    //添加店铺标题
    CGSize size = [titleLabel currentSizeWithString:_dataModel.title font:FONT(14) withWidth:0];
    CGFloat width = (size.width > 150) ? 150 : size.width;
    titleLabel.frame = FRAME(100, 10, width, 20);
    titleLabel.text = dataModel.title;
    titleLabel.font = FONT(14);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    //添加starView
    [starView removeFromSuperview];
    starView = nil;
    starView = [XHStarView addEvaluateViewWithStarNO:[dataModel.score floatValue]/
                                                     [dataModel.comments floatValue]
                                           withFrame:FRAME(100, 42, 70, 15)];
    
    //添加优惠view
    [youhuiView removeFromSuperview];
    youhuiView = nil;
    youhuiView = [[UIView alloc] initWithFrame:FRAME(width + 105, 12.5, 100, 15)];
    youhuiView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *youhuiArray = [self handleYouhuiArrayWith:dataModel];
    NSInteger count = youhuiArray.count;
    if (count > 0) {//该店铺有优惠
        for (int i = 0; i < count; i++) {
            //循环创建优惠项目
            UIImageView *iv = [[UIImageView alloc] initWithFrame:FRAME(i * 20, 0, 15, 15)];
            iv.image = IMAGE(youhuiArray[i]);
            [youhuiView addSubview:iv];
        }
    }
    
    //添加人均消费label
    costLabel.frame = FRAME(WIDTH - 85, 25, 80, 15);
    costLabel.textAlignment = NSTextAlignmentLeft;
    costLabel.font = FONT(14);
    costLabel.textColor = HEX(@"999999", 1.0f);
    NSString *costString = [NSString stringWithFormat:NSLocalizedString(@"人均: ¥%g", nil),[dataModel.avg_amount floatValue]];
    NSInteger stringLen = costString.length;
    //富文本
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:costString];
    
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:SPECIAL_COLOR
                           range:NSMakeRange(3, stringLen - 3)];
    costLabel.attributedText = AttributedStr1;
    
    //添加店铺类型
    typeLabel.frame = FRAME(100, 70, 100, 20);
    typeLabel.text = dataModel.cate_title;
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.textColor = HEX(@"999999", 1.0f);
    typeLabel.font = FONT(14);
    //距离标签
    [distanceView removeFromSuperview];
    distanceView = nil;
    distanceView = [[UIView alloc] initWithFrame:FRAME(WIDTH - 90, 45, 85, 12)];
    UIImageView *zuobiaoIV = [[UIImageView alloc] initWithFrame:FRAME(0,1.5, 8, 11)];
    zuobiaoIV.image = IMAGE(@"zuobaio2");
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:FRAME(13, 0, 70, 14)];
    distanceLabel.font = FONT(14);
    //计算距离
    distanceLabel.text = dataModel.juli_label;
    distanceLabel.textColor = [UIColor lightGrayColor];
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    [distanceView addSubview:zuobiaoIV];
    [distanceView addSubview:distanceLabel];
    
    //添加到cell上
    [self addSubview:youhuiView];
    [self addSubview:starView];
    [self addSubview:distanceView];
}
#pragma mark - 处理优惠信息
- (NSMutableArray *)handleYouhuiArrayWith:(JHHomePageShopItemModel *)dataModel
{
    NSMutableArray *youhuiArray = [@[] mutableCopy];
    if ([dataModel.have_maidan integerValue] == 1) {
        [youhuiArray addObject:@"hui"];
    }
    if ([dataModel.have_quan integerValue] == 1) {
        [youhuiArray addObject:@"quan"];
    }
    if ([dataModel.have_tuan integerValue] == 1) {
        [youhuiArray addObject:@"tuan"];
    }
    if ([dataModel.have_waimai integerValue] == 1) {
        [youhuiArray addObject:@"icon-wai"];
    }
    return youhuiArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    starView.backView.backgroundColor = [UIColor colorWithPatternImage:starView.grayStarImage];
    starView.topView.backgroundColor = [UIColor colorWithPatternImage:starView.colorStarImage];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    starView.backView.backgroundColor = [UIColor colorWithPatternImage:starView.grayStarImage];
    starView.topView.backgroundColor = [UIColor colorWithPatternImage:starView.colorStarImage];
}
@end
