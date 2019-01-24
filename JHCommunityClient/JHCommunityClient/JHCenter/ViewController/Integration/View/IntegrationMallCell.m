//
//  iIntegrationMallCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "IntegrationMallCell.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+NetStatus.h"
@implementation IntegrationMallCell
- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(0, 0, (WIDTH - 30)/2, ((WIDTH - 30)/2 - 10)/1.35)];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        //self.titleLabel = [[UILabel alloc] initWithFrame:FRAME(10,  ((WIDTH - 30)/2 - 10)/1.35 + 5, 100, 15)];
        self.titleLabel = [UILabel new];
        self.titleLabel.font = FONT(12);
        self.titleLabel.textColor = HEX(@"333333", 1.0f);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.right.offset = -10;
            make.top.equalTo(self.iconImg.mas_bottom).offset = 10;
            make.height.offset = 12;
        }];
        //self.codeLabel = [[UILabel alloc] initWithFrame:FRAME(10,((WIDTH - 30)/2 - 10)/1.35 + 30, 100, 15)];
        self.codeLabel = [UILabel new];
        [self.iconImg addSubview:self.codeLabel];
        self.codeLabel.font = FONT(12);
        self.codeLabel.textColor = [UIColor whiteColor];
        self.codeLabel.textAlignment = NSTextAlignmentCenter;
        self.codeLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.bottom.offset = 0;
            make.width.offset = 70;
            make.height.offset = 25;
        }];
        
        self.priceLabel = [UILabel new];
        self.priceLabel.font = FONT(14);
        self.priceLabel.textColor = HEX(@"ff6600", 1.0f);
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.top.equalTo(self.titleLabel.mas_bottom).offset = 10;
            make.right.offset = -40;
        }];
       
        
        self.addBnt = [UIButton buttonWithType:UIButtonTypeCustom];
         [self.contentView addSubview:self.addBnt];
        [self.addBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = 0;
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(self.priceLabel);
        }];
        //self.addBnt.frame = FRAME(self.frame.size.width - 50, ((WIDTH - 30)/2 - 10)/1.35 + 20, 40, 20);
        self.addBnt.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.addBnt setImage:IMAGE(@"jiahao") forState:0];
        [self.addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateHighlighted];
        [self.addBnt setImage:IMAGE(@"jiahao") forState:UIControlStateSelected];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setIntegrationMallModel:(IntegrationMallModel *)integrationMallModel
{
    _integrationMallModel = integrationMallModel;
     self.titleLabel.text = integrationMallModel.title;
     self.codeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@积分", nil),integrationMallModel.jifen];
//    NSRange range = [string rangeOfString:integrationMallModel.jifen];
//    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:string];
//    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"f85357" alpha:1.0]} range:range];
//    [attribute addAttributes:@{NSFontAttributeName:FONT(12)} range:range];
//    self.codeLabel.text = string;
//    self.codeLabel.attributedText = attribute;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:integrationMallModel. photo]];
    [self.iconImg sd_image:url plimage:IMAGE(@"jfproduct290x200")];
    self.priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"支付¥%@", nil),integrationMallModel.price];
    NSMutableAttributedString *priceAttributed = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
    NSRange priceRange = [_priceLabel.text rangeOfString:NSLocalizedString(@"支付", nil)];
    [priceAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"b6b6b6", 1.0f)} range:priceRange];
    self.priceLabel.attributedText = priceAttributed;
}
@end
