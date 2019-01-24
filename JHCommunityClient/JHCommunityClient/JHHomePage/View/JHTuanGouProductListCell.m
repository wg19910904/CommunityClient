//
//  JHTuanGouListCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHTuanGouProductListCell.h"
#import <UIImageView+WebCache.h>

@implementation JHTuanGouProductListCell
{
    UIImageView *leftIV;
    UILabel *titleLabel;
    UILabel *pricelLabel;
    UILabel *storePriceLabel;
    UILabel *numLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = FRAME(0, 0, WIDTH, 100);
        //添加控件
        [self createSubviews];
    }
    return self;
}
#pragma mark - 创建子控件
- (void)createSubviews
{
    leftIV = [UIImageView new];
    titleLabel = [UILabel new];
    pricelLabel = [UILabel new];
    storePriceLabel = [UILabel new];
    numLabel = [UILabel new];
//    //添加下边线
//    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0,69.5, WIDTH, 0.5)];
//    lineView.backgroundColor = LINE_COLOR;
//    [self addSubview:lineView];
    [self addSubview:leftIV];
    [self addSubview:titleLabel];
    [self addSubview:pricelLabel];
    [self addSubview:storePriceLabel];
    [self addSubview:numLabel];
}
#pragma mark - 外部字典传入时,重设控件frame
- (void)setDataModel:(JHTuanGouProductListCellModel *)dataModel
{
    _dataModel = dataModel;
    //重设控件
    leftIV.frame = FRAME(10, 10, 80, 80);
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.photo]];
    [leftIV sd_setImageWithURL:url placeholderImage:IMAGE(@"shopDefault")];
    
    titleLabel.frame = FRAME(100, 12, WIDTH - 80, 20);
    titleLabel.text = dataModel.title;
    titleLabel.font = FONT(13);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    pricelLabel.frame = FRAME(100, 40, 60, 20);
    pricelLabel.font = FONT(14);
    pricelLabel.text =  [NSString stringWithFormat:@"¥%g",[dataModel.price floatValue]];
    pricelLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0];
    
    storePriceLabel.frame = FRAME(150, 40, WIDTH - 150, 20);
    storePriceLabel.textColor = HEX(@"999999", 1.0f);
    storePriceLabel.text = [NSString stringWithFormat:@"%@%g",NSLocalizedString(@"门市价: ¥", nil),[dataModel.market_price floatValue ]];
    storePriceLabel.font = FONT(12);
    
    numLabel.frame = FRAME(100, 70, 150, 20);
    numLabel.textColor = HEX(@"999999", 1.0f);
    numLabel.text = [NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"已售:", nil),[dataModel.sales integerValue] + [dataModel.virtual_sales integerValue]];
    numLabel.font = FONT(12);
    
}
@end
