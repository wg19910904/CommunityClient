//
//  JHShopHomePageWaiCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/6/14.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHShopHomePageWaiCell.h"
CGFloat JHShopHomePageWaiCell_height;
@implementation JHShopHomePageWaiCell
{
    CALayer *separator1;
    CALayer *separator2;
    
    UIImageView *leftIV;
    UILabel *titleL;
    UILabel *ordersL;
    
    CALayer *line1;
    CALayer *line2;
    

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //makeUI
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    separator1 = [CALayer layer];
    separator1.frame = FRAME(0, 0, WIDTH, 10);
    separator1.backgroundColor = BACK_COLOR.CGColor;
    [self.layer addSublayer:separator1];
    
    separator2 = [CALayer layer];
    separator2.frame = FRAME(0, 50, WIDTH, 10);
    separator2.backgroundColor = BACK_COLOR.CGColor;
    [self.layer addSublayer:separator2];
    
    //添加左侧图片
    leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 22, 16, 16)];
    leftIV.image = IMAGE(@"wai");
    [self addSubview:leftIV];
    
    titleL = [[UILabel alloc] initWithFrame:FRAME(30,10, WIDTH - 60, 40)];
    titleL.font = FONT(13);
    titleL.textColor = HEX(@"333333", 1.0f);
    [self addSubview:titleL];
    
    UIImageView *rightIV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 19, 22.5, 9, 15)];
    rightIV.image = IMAGE(@"jiantou_1");
    [self addSubview:rightIV];
    
    line1 = [CALayer layer];
    line1.frame = FRAME(0, 10, WIDTH, 0.5);
    line1.backgroundColor =LINE_COLOR.CGColor;
    
    
    line2 = [CALayer layer];
    line2.frame = FRAME(0, 50, WIDTH, 0.5);
    line2.backgroundColor =LINE_COLOR.CGColor;
    
    [self.layer addSublayer:line1];
    [self.layer addSublayer:line2];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.frame = FRAME(0, 0, WIDTH, JHShopHomePageWaiCell_height);
    if (JHShopHomePageWaiCell_height == 0) {
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj = nil;
        }];
        

        [separator1 removeFromSuperlayer];
        [separator2 removeFromSuperlayer];
        separator1 = nil;
        separator2 = nil;
        
        [line1 removeFromSuperlayer];
        line1 = nil;
        [line2 removeFromSuperlayer];
        line2 = nil;
        
    }else{
        
        titleL.text = [NSString stringWithFormat:NSLocalizedString(@"本店铺%g公里以内送外卖", nil),[dataDic[@"pei_distance"] floatValue]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    separator1.backgroundColor = BACK_COLOR.CGColor;
    separator2.backgroundColor = BACK_COLOR.CGColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    separator1.backgroundColor = BACK_COLOR.CGColor;
    separator2.backgroundColor = BACK_COLOR.CGColor;
}



+ (CGFloat)getHeight:(NSString *)haveWaiMai
{
    if ([haveWaiMai integerValue] == 0) {
        JHShopHomePageWaiCell_height = 0;
    }else{
    
        JHShopHomePageWaiCell_height = 60;
    }
    return JHShopHomePageWaiCell_height;
}
@end
