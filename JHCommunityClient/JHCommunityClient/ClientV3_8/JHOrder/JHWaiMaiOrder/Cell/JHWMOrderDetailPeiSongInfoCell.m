//
//  JHWMDetailPeiSongInfoCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderDetailPeiSongInfoCell.h"
#import "NSString+Tool.h"

@interface JHWMOrderDetailPeiSongInfoCell ()
@property(nonatomic,weak)UILabel *sendTimeLab;
@property(nonatomic,weak)UILabel *addressLab;
@property(nonatomic,weak)UILabel *sendTypeLab;
@end

@implementation JHWMOrderDetailPeiSongInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.height.offset(20);
    }];
    titleLab.font = FONT(15);
    titleLab.textColor = TEXT_COLOR;
    titleLab.text =  NSLocalizedString(@"配送信息", NSStringFromClass([self class]));
    
    UILabel *sendTimeLab = [UILabel new];
    [self.contentView addSubview:sendTimeLab];
    [sendTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    sendTimeLab.font = FONT(13);
    sendTimeLab.textColor = HEX(@"999999", 1.0);
    self.sendTimeLab = sendTimeLab;
    
    UILabel *addrLab = [UILabel new];
    [self.contentView addSubview:addrLab];
    [addrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(sendTimeLab.mas_bottom).offset(10);
        make.height.offset(20);
        make.width.offset(62);
    }];
    addrLab.font = FONT(13);
    addrLab.textColor = HEX(@"999999", 1.0);
    addrLab.text =  NSLocalizedString(@"收货地址:", NSStringFromClass([self class]));
    
    UILabel *addressLab = [UILabel new];
    [self.contentView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrLab.mas_right);
        make.right.offset(-10);
        make.top.equalTo(addrLab.mas_top).offset(3);
    }];
    addressLab.font = FONT(13);
    addressLab.numberOfLines = 0;
    addressLab.textColor = HEX(@"333333", 1.0);
    self.addressLab = addressLab;
    
    UILabel *sendTypeLab = [UILabel new];
    [self.contentView addSubview:sendTypeLab];
    [sendTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(addressLab.mas_bottom).offset(10);
        make.height.offset(20);
        make.bottom.offset(-10);
    }];
    sendTypeLab.font = FONT(13);
    sendTypeLab.textColor = HEX(@"999999", 1.0);
    self.sendTypeLab = sendTypeLab;
}

-(void)reloadCellWithInfo:(JHWaiMaiModel *)model{
    
    NSString *str = model.pei_time;
    if ([model.pei_time isEqualToString:@"0"]) {
        if ([model.pei_type isEqualToString:@"3"]) str = @"立即自提";//自提
        else str = @"立即送达";
    }
    
    NSString *time_str = [NSString stringWithFormat: NSLocalizedString(@"送达时间: %@", NSStringFromClass([self class])),str];
    self.sendTimeLab.attributedText = [NSString getAttributeString:time_str dealStr:str strAttributeDic:@{NSForegroundColorAttributeName : TEXT_COLOR}];
   
    NSString *addrStr = [NSString stringWithFormat:@"%@  \n%@  \n%@",model.contact,model.mobile,model.addr];
    self.addressLab.attributedText = [NSString getParagraphStyleAttributeStr:addrStr lineSpacing:5.0];
    
    // 配送方式 0商家送，1平台送，3自提，4堂食
    NSString *pei_type =  NSLocalizedString(@"商家配送", NSStringFromClass([self class]));
    if ([model.pei_type isEqualToString:@"1"]) pei_type =  NSLocalizedString(@"平台配送", NSStringFromClass([self class]));
    if ([model.pei_type isEqualToString:@"3"]) pei_type =  NSLocalizedString(@"客户自提", NSStringFromClass([self class]));
    if ([model.pei_type isEqualToString:@"4"]) pei_type =  NSLocalizedString(@"到店堂食", NSStringFromClass([self class]));
    
    NSString *pei_str = [NSString stringWithFormat: NSLocalizedString(@"配送方式: %@", NSStringFromClass([self class])),pei_type];
    self.sendTypeLab.attributedText = [NSString getAttributeString:pei_str dealStr:pei_type strAttributeDic:@{NSForegroundColorAttributeName : TEXT_COLOR}];
}

@end
