//
//  JHSubmitIntegrationOrderCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHSubmitIntegrationOrderCell.h"
#import "UIImageView+NetStatus.h"
@implementation JHSubmitIntegrationOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark-===初始化子控件
- (void)initSubViews{
    _iconImg = [UIImageView new];
    [self.contentView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 10;
        make.size.mas_equalTo(CGSizeMake(90,60));
    }];
    
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 10;
        make.top.offset = 10;
        make.right.offset = 0;
        make.height.offset = 14;
    }];
    
    _price = [UILabel new];
    _price.font = FONT(12);
    _price.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 10;
        make.top.equalTo(_title.mas_bottom).offset = 12;
        make.right.offset = 0;
        make.height.offset = 12;
    }];
   
    
    _number = [UILabel new];
    _number.font = FONT(12);
    _number.textColor = HEX(@"999999", 1.0f);
    [self.contentView addSubview:_number];
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 10;
        make.top.equalTo(_price.mas_bottom).offset = 10;
        make.right.offset = -70;
        make.height.offset = 12;
    }];
    
    _addBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_addBnt];
    [_addBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.top.equalTo(self.title.mas_bottom).offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 30;
    }];
//    _addBnt.backgroundColor = [UIColor redColor];
    _addBnt.imageEdgeInsets = UIEdgeInsetsMake(30, 0, 6, 10);
    [_addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateNormal];
    [_addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateHighlighted];
    [_addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateSelected];
    
    _buyNumber = [UILabel new];
    _buyNumber.font = FONT(12);
    
    _buyNumber.textColor = HEX(@"333333", 1.0f);
    _buyNumber.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_buyNumber];
    [_buyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_number);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.offset = -30;
    }];
    _subBnt = [UIButton buttonWithType:UIButtonTypeCustom];
//    _subBnt.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_subBnt];
    [_subBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -50;
        make.top.equalTo(self.title.mas_bottom).offset = 0;
        make.bottom.offset = 0;
        make.width.offset = 30;
    }];
    _subBnt.imageEdgeInsets = UIEdgeInsetsMake(30, 10, 6, 0);
    [_subBnt setImage:IMAGE(@"jian") forState:UIControlStateNormal];
    [_subBnt setImage:IMAGE(@"jian") forState:UIControlStateHighlighted];
    [_subBnt setImage:IMAGE(@"jian") forState:UIControlStateSelected];
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [_iconImg sd_image:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataDic[@"image_url"]]] plimage:IMAGE(@"jfproduct290x200")];
    _price.text = [NSString stringWithFormat:@"¥%@ %@积分",dataDic[@"price"],dataDic[@"jifen"]];
    NSMutableAttributedString *priceAttributed = [[NSMutableAttributedString alloc] initWithString:_price.text];
    NSRange priceRange1 = [_price.text rangeOfString:[NSString stringWithFormat:@"¥%@",dataDic[@"price"]]];
    NSRange priceRange2 = [_price.text rangeOfString:NSLocalizedString(@"积分", nil)];
    [priceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff6600", 1.0f)} range:priceRange1];
    [priceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:priceRange2];
    _price.attributedText = priceAttributed;
    _title.text = [NSString stringWithFormat:@"%@",_dataDic[@"product_title"]];
    _number.text = [NSString stringWithFormat:NSLocalizedString(@"剩余数量:%@", nil),_dataDic[@"sku"]];
    _buyNumber.text = [NSString stringWithFormat:@"%@",_dataDic[@"product_number"]];
}
@end
