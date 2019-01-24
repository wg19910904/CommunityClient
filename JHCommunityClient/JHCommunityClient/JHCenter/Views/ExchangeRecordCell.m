//
//  ExchangeRecordCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/3/1.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "ExchangeRecordCell.h"
#import "UIImageView+NetStatus.h"
//#import "UIImageView+WebCache.h"
@implementation ExchangeRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.iconImg = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 90, 60)];
        self.iconImg.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImg.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImg];
        self.titleLabel = [[UILabel alloc] initWithFrame:FRAME(110, 10, WIDTH - 110, 10)];
        self.titleLabel.font = FONT(14);
        self.titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLabel];
        self.codeLabel = [[UILabel alloc] initWithFrame:FRAME(110, 30, WIDTH - 110, 10)];
        self.codeLabel.font = FONT(14);
        self.codeLabel.textColor = HEX(@"999999", 1.0f);
        [self.contentView addSubview:self.codeLabel];
        self.exchangeStatus = [[UILabel alloc] initWithFrame:FRAME(110, 50, WIDTH - 110, 10)];
        self.exchangeStatus.font = FONT(14);
        self.exchangeStatus.text = NSLocalizedString(@"兑换成功", nil);
        self.exchangeStatus.textColor = HEX(@"f85357", 1.0f);
        [self.contentView addSubview:self.exchangeStatus];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
- (void)setExchangeRecordModel:(ExchangeRecordModel *)exchangeRecordModel
{
    _exchangeRecordModel = exchangeRecordModel;
    self.titleLabel.text = exchangeRecordModel.product_name;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:exchangeRecordModel.photo]];
    [self.iconImg sd_image:url plimage:IMAGE(@"jfproduct180x120")];
     self.codeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld积分", nil),[exchangeRecordModel.product_jifen integerValue]];
}

@end
