//
//  JHPayFeeBillCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayFeeBillCell.h"

@implementation JHPayFeeBillCell
{
    UIView *_bottomLine;//底部线条
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    _iconImg = [UIImageView new];
    [self.contentView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    _iconImg.image = IMAGE(@"pay_1");
    _iconImg.layer.cornerRadius = 20.0f;
    _iconImg.clipsToBounds = YES;
    
    _infoLabel = [UILabel new];
    [self.contentView addSubview:_infoLabel];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 15;
        make.right.offset = -95;
        make.top.offset = 15;
        make.height.offset = 14;
    }];
    _infoLabel.font = FONT(14);
    _infoLabel.textColor = HEX(@"333333", 1.0f);
   
    
    _timeLabel = [UILabel new];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 15;
        make.top.equalTo(_infoLabel.mas_bottom).offset = 10;
        make.right.offset = -80;
        make.height.offset = 14;
        
    }];
    _timeLabel.font = FONT(12);
    _timeLabel.textColor = HEX(@"999999", 1.0f);
  
    
    _feeLabel = [UILabel new];
    [self.contentView addSubview:_feeLabel];
    [_feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.width.offset = 80;
        make.centerY.equalTo(_infoLabel);
        make.height.offset = 14;
    }];
    _feeLabel.font = FONT(14);
    _feeLabel.textColor = HEX(@"333333", 1.0f);
    _feeLabel.textAlignment = NSTextAlignmentRight;
   
    
    _status = [UILabel new];
    [self.contentView addSubview:_status];
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(_timeLabel);
        make.width.offset = 80;
        make.height.offset = 11;
    }];
    _status.font = FONT(11);
    _status.textAlignment = NSTextAlignmentRight;
  
    _bottomLine = [UIView new];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    _bottomLine.backgroundColor = LINE_COLOR;
    
}
- (void)setPayFeeBillListModel:(JHPayFeeBillListModel *)payFeeBillListModel{
    _payFeeBillListModel = payFeeBillListModel;
    _infoLabel.text = [NSString stringWithFormat:@"%@ %@",payFeeBillListModel.yezhu_name,payFeeBillListModel.yezhu_house];
    _timeLabel.text = [self transfromWithString:payFeeBillListModel.dateline];
    _feeLabel.text = [NSString stringWithFormat:@"¥%@",payFeeBillListModel.total_price];
    if([payFeeBillListModel.pay_status isEqualToString:@"0"]){
        _status.textColor = HEX(@"ff3300", 1.0f);
        _status.text = NSLocalizedString(@"待支付", nil);
    }else if([payFeeBillListModel.pay_status isEqualToString:@"1"]){
        _status.textColor = HEX(@"59c181", 1.0f);
        _status.text = NSLocalizedString(@"已支付", nil);
    }
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
