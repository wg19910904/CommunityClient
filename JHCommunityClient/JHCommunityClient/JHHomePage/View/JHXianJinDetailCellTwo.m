//
//  JHTuanGouDetailCellTwo.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/10.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHXianJinDetailCellTwo.h"
#import "UILabel+SuitableHeight.h"

@implementation JHXianJinDetailCellTwo
{
    UILabel *expiryDateTitleLabel;
    UILabel *expiryDateLabel;
    UILabel *ruleTitleLabel;
    UILabel *ruleLabel;
    UIView *lineView1;
    UIView *lineView2;
    UIView *lineView3;
    UILabel *arrowLabel;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        //添加控件
        [self createSubviews];
    }
    return self;
}
#pragma mark - 添加子控件
- (void)createSubviews
{
    expiryDateTitleLabel = [UILabel new];
    expiryDateLabel = [UILabel new];
    ruleTitleLabel = [UILabel new];
    ruleLabel = [UILabel new];
    _detailBtn = [UIButton new];
    lineView1 = [UIView new];
    lineView2 = [UIView new];
    lineView3 = [UIView new];

    [self addSubview:expiryDateTitleLabel];
    [self addSubview:expiryDateLabel];
    [self addSubview:ruleTitleLabel];
    [self addSubview:ruleLabel];
    [self addSubview:lineView1];
    [self addSubview:lineView2];
    [self addSubview:lineView3];
    [self addSubview:_detailBtn];

}
#pragma mark - 外部参数传入时,重设frame
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    lineView1.frame = FRAME(0, 0,WIDTH, 0.5);
    lineView1.backgroundColor = LINE_COLOR;
    //重设frame
    expiryDateTitleLabel.frame = FRAME(10, 5, WIDTH - 20, 20);
    expiryDateTitleLabel.text = NSLocalizedString(@"有效期:", nil);
    expiryDateTitleLabel.font = FONT(12);
    expiryDateTitleLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0];
    
    expiryDateLabel.frame = FRAME(10, 25, WIDTH -20, 20);
    expiryDateLabel.text = @"2016.01.20-2016.02.10";
    expiryDateLabel.font = FONT(12);
    expiryDateLabel.textColor = HEX(@"999999", 1.0);
    
    ruleTitleLabel.frame = FRAME(10, 45, WIDTH - 20, 20);
    ruleTitleLabel.text = NSLocalizedString(@"使用时间:", nil);
    ruleTitleLabel.font = FONT(12);
    ruleTitleLabel.textColor = [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1.0];
    
    ruleLabel.frame = FRAME(10,65, WIDTH - 20, 30);
    ruleLabel.text = @"";
    ruleLabel.textColor = HEX(@"999999", 1.0);
    ruleLabel.font = FONT(12);
    CGFloat height = [ruleLabel getLabelFitHeight:ruleLabel withFont:FONT(12)];
    ruleLabel.frame = FRAME(10, 65, WIDTH - 20, height);
    
    lineView2.frame = FRAME(0,75+height, WIDTH, 0.5);
    lineView2.backgroundColor = LINE_COLOR;

    _detailBtn.frame = FRAME(0, 75+height, WIDTH, 30);
    _detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WIDTH - 92);
    [_detailBtn setTitle:NSLocalizedString(@"图文详情 >>", nil) forState:UIControlStateNormal];
    [_detailBtn setTitleColor:HEX(@"333333", 1.0f) forState:UIControlStateNormal];
    [_detailBtn setTitleColor:HEX(@"999999", 1.0f) forState:UIControlStateHighlighted];
    _detailBtn.titleLabel.font = FONT(13);
    
    lineView3.frame = FRAME(0, 104.5 + height, WIDTH, 0.5);
    lineView3.backgroundColor = LINE_COLOR;
    self.frame = FRAME(0, 0, WIDTH, 105 + height);
}
@end
