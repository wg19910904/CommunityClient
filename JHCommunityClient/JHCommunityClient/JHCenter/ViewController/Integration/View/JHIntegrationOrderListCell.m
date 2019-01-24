//
//  JHIntegrationOrderListCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationOrderListCell.h"
#import "NSObject+CGSize.h"
#import "UIImageView+NetStatus.h"
@implementation JHIntegrationOrderListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--====初始化子控件
- (void)initSubView{
    _iconImg = [UIImageView new];
    
    _iconImg.layer.cornerRadius = 4.0f;
    _iconImg.clipsToBounds = YES;
    [self.contentView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.top.offset = 10;
        make.size.mas_equalTo(CGSizeMake(80,60));
    }];
    
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    _title.numberOfLines = 0;
    [self.contentView addSubview:_title];
   
    
    _price = [UILabel new];
    _price.textColor = HEX(@"333333", 1.0);
    _price.font = FONT(12);
    
    [self.contentView addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 10;
        make.bottom.offset = -10;
        make.right.offset = -90;
        make.height.offset = 12;
    }];
   
    
    _num = [UILabel new];
    _num.textColor= HEX(@"333333", 1.0f);
    _num.font = FONT(12);
   
    _num.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_num];
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = - 10;
        make.width.offset = 70;
        make.centerY.equalTo(_price);
        make.height.offset = 12;
    }];
    
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
- (void)setIntegrationProductModel:(JHIntegrationOrderProductModel *)integrationProductModel{
    _integrationProductModel = integrationProductModel;
    [_iconImg sd_image:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:integrationProductModel.product_photo]] plimage:IMAGE(@"jfproduct290x200")];
    _title.text = integrationProductModel.product_name;
    CGSize titleSize = [self currentSizeWithString:_title.text font:FONT(14) withWidth:110];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 10;
        make.right.offset = -10;
        make.top.offset = 10;
        make.height.offset = titleSize.height;
    }];
    _price.text = [NSString stringWithFormat:@"¥%@ %@积分",integrationProductModel.product_price,integrationProductModel.product_jifen];
    NSMutableAttributedString *priceAttributed = [[NSMutableAttributedString alloc] initWithString:_price.text];
    NSRange priceRange1 = [_price.text rangeOfString:[NSString stringWithFormat:@"¥%@",integrationProductModel.product_price]];
    NSRange priceRange2 = [_price.text rangeOfString:NSLocalizedString(@"积分", nil)];
    [priceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff6600", 1.0f)} range:priceRange1];
    [priceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:priceRange2];
    _price.attributedText = priceAttributed;
     _num.text = [NSString stringWithFormat:@"x%@",integrationProductModel.product_number];
}
@end
