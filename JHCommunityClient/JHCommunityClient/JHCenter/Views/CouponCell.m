//
//  CouponCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/4/12.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "CouponCell.h"
#import "UIImageView+NetStatus.h"
#import "UIImage+MDQRCode.h"
@implementation CouponCell
{
    UIView *_middleLine;
    UIView *_codeImgBack;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = HEX(@"f5f5f5", 1.0f);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initSubViews{
    self.backImg =[[UIImageView alloc] initWithFrame:FRAME(10, 2, WIDTH - 20, 160)];
    self.backImg.image = IMAGE(@"quan_bg");
    [self.contentView addSubview:self.backImg];
    self.title = [[UILabel alloc] initWithFrame:FRAME(10, 20, _backImg.frame.size.width - 20, 20)];
    self.title.font = FONT(16);
    self.title.textColor = HEX(@"333333", 1.0f);
    [self.backImg addSubview:self.title];
    _middleLine = [[UIView alloc]initWithFrame:FRAME(10, 49.5, _backImg.frame.size.width - 20, 0.5)];
    _middleLine.backgroundColor= LINE_COLOR;
    [self.contentView addSubview:_middleLine];
    _codeImgBack = [[UIView alloc] initWithFrame:FRAME(10, 60, 75, 75)];
    _codeImgBack.backgroundColor = [UIColor whiteColor];
    _codeImgBack.layer.cornerRadius = 4.0f;
    _codeImgBack.clipsToBounds = YES;
    _codeImgBack.layer.borderWidth = 0.5f;
    _codeImgBack.layer.borderColor = LINE_COLOR.CGColor;
    [_backImg addSubview:_codeImgBack];
    _codeImg = [[UIImageView alloc] initWithFrame:FRAME(2.5, 2.5, 70, 70)];
    [_codeImgBack addSubview:_codeImg];
    self.password = [[UILabel alloc] initWithFrame:FRAME(105, 65, _backImg.frame.size.width - 105, 15)];
    self.password.font = FONT(14);
    self.password.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:self.password];
    self.time = [[UILabel alloc] initWithFrame:FRAME(105, 90,_backImg.frame.size.width - 105, 15)];
    self.time.font = FONT(14);
    self.time.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:self.time];
    self.money = [[UILabel alloc] initWithFrame:FRAME(105, 115, _backImg.frame.size.width - 105, 20)];
    self.money.textColor = HEX(@"ff6600", 1.0f);
    self.money.font = FONT(16);
    [self.contentView addSubview:self.money];
}
- (void)setCouponModel:(CouponModel *)couponModel
{
    _couponModel = couponModel;
    self.title.text = couponModel.detail_title;
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"￥%@ x%@", nil),couponModel.detail_price,couponModel.count];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"x%@",couponModel.count]];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    self.money.attributedText = attributed;
    self.password.text = [NSString stringWithFormat:NSLocalizedString(@"密码:%@", nil),couponModel.number];
    self.time.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至:%@", nil),[self transfromWithString:couponModel.ltime]];
    self.codeImg.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%@",couponModel.number] size:self.codeImg.bounds.size.width fillColor:[UIColor darkGrayColor]];
}
//时间戳转换时间
- (NSString *)transfromWithString:(NSString *)str
{
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end
