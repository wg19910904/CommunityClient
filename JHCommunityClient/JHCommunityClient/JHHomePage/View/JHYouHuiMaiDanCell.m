//
//  JHYouHuiMaiDanCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/6/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHYouHuiMaiDanCell.h"
#import "NSObject+CGSize.h"
@implementation JHYouHuiMaiDanCell
{
    UILabel *_youhuiLabel;
    CALayer *lineLayer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加控件
        [self makeUI];
    }
    
    return self;
}
#pragma mark - 添加控件
- (void)makeUI
{
    _youhuiLabel = [[UILabel alloc]initWithFrame: FRAME(10, 0, WIDTH - 20, CGRectGetHeight(self.bounds))];
    _youhuiLabel.textColor = HEX(@"666666", 1.0F);
    _youhuiLabel.font = FONT(16);
    _youhuiLabel.text = NSLocalizedString(@"优惠信息", nil);
    _youhuiLabel.numberOfLines = 0;
    [self addSubview:_youhuiLabel];
    //添加下边线
    lineLayer = [[CALayer alloc]init];
    lineLayer.frame = FRAME(0, 39.5, WIDTH, 0.5);
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:lineLayer];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    NSString *title = dataDic[@"title"];
    CGSize size = [@[] currentSizeWithString:title font:FONT(16) withWidth:20];
    CGFloat height = (size.height + 10) > 44 ? (size.height + 10) : 44;
    _youhuiLabel.frame = FRAME(10, 0, WIDTH - 20, height);
    _youhuiLabel.text = title;
    lineLayer.frame = FRAME(0, height - 0.5, WIDTH, 0.5);
}

+ (CGFloat)getHeight:(NSString *)string
{
    CGSize size = [@[] currentSizeWithString:string font:FONT(16) withWidth:20];
    CGFloat height = size.height + 10;
    return  height > 44 ? height : 44;
}
@end
