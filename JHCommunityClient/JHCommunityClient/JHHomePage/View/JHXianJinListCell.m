//
//  JHTuanGouListCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHXianJinListCell.h"
#import <UIImageView+WebCache.h>

@implementation JHXianJinListCell
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
        self.frame = FRAME(0, 0, WIDTH, 70);
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
    //添加下边线
    UIView *lineView = [[UIView alloc] initWithFrame:FRAME(0,69.5, WIDTH, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [self addSubview:lineView];
    
    [self addSubview:leftIV];
    [self addSubview:titleLabel];
    [self addSubview:pricelLabel];
    [self addSubview:storePriceLabel];
    [self addSubview:numLabel];
}
#pragma mark - 外部字典传入时,重设控件frame
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    //重设控件
    leftIV.frame = FRAME(10, 10, 50, 50);
    leftIV.image = IMAGE(@"lobster");
    
    titleLabel.frame = FRAME(70, 5, WIDTH - 80, 20);
    titleLabel.text = NSLocalizedString(@"现金券名称", nil);
    titleLabel.font = FONT(13);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    
    pricelLabel.frame = FRAME(70, 25, 60, 20);
    pricelLabel.font = FONT(14);
    pricelLabel.text = @"¥173";
    pricelLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0];
    
    storePriceLabel.frame = FRAME(130, 25, WIDTH - 150, 20);
    storePriceLabel.textColor = HEX(@"999999", 1.0f);
    storePriceLabel.text = NSLocalizedString(@"门市价: ¥50", nil);
    storePriceLabel.font = FONT(12);
    
    numLabel.frame = FRAME(70, 45, 150, 20);
    numLabel.textColor = HEX(@"999999", 1.0f);
    numLabel.text = NSLocalizedString(@"已售500", nil);
    numLabel.font = FONT(12);
    
}
@end
