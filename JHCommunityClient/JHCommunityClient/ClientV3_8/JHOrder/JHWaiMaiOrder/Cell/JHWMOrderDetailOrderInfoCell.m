//
//  JHWMDetailOrderInfoCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderDetailOrderInfoCell.h"
#import "NSString+Tool.h"

@interface JHWMOrderDetailOrderInfoCell ()
@property(nonatomic,weak)UILabel *orderNumLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *payTypeLab;
@property(nonatomic,weak)UILabel *noteLab;
@end

@implementation JHWMOrderDetailOrderInfoCell

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
    titleLab.text =  NSLocalizedString(@"订单详情", NSStringFromClass([self class]));
    
    UILabel *orderNumLab = [UILabel new];
    [self.contentView addSubview:orderNumLab];
    [orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    orderNumLab.font = FONT(13);
    orderNumLab.textColor = HEX(@"999999", 1.0);
    self.orderNumLab = orderNumLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(orderNumLab.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    timeLab.font = FONT(13);
    timeLab.textColor = HEX(@"999999", 1.0);
    self.timeLab = timeLab;
    
    UILabel *payTypeLab = [UILabel new];
    [self.contentView addSubview:payTypeLab];
    [payTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(timeLab.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    payTypeLab.font = FONT(13);
    payTypeLab.textColor = HEX(@"999999", 1.0);
    self.payTypeLab = payTypeLab;
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(payTypeLab.mas_bottom).offset(10);
        make.height.offset(20);
        make.width.offset(62);
    }];
    lab.font = FONT(13);
    lab.textColor = HEX(@"999999", 1.0);
    lab.text = NSLocalizedString(@"订单备注:", NSStringFromClass([self class]));
    
    UILabel *noteLab = [UILabel new];
    [self.contentView addSubview:noteLab];
    [noteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab.mas_right);
        make.right.offset(-10);
        make.top.equalTo(lab.mas_top).offset(3);
        make.bottom.offset(-10);
    }];
    noteLab.numberOfLines = 0;
    noteLab.font = FONT(13);
    noteLab.textColor = TEXT_COLOR;
    self.noteLab = noteLab;
   
}

-(void)reloadCellWithInfo:(JHWaiMaiModel *)model{
    
    NSString* order_id_str = [NSString stringWithFormat:NSLocalizedString(@"订单号:     %@", NSStringFromClass([self class])),model.order_id];
    self.orderNumLab.attributedText = [NSString getAttributeString:order_id_str dealStr:model.order_id strAttributeDic:@{NSForegroundColorAttributeName : TEXT_COLOR}];
    
    NSString* time_str = [NSString stringWithFormat:NSLocalizedString(@"下单时间: %@", NSStringFromClass([self class])),model.dateline];
    self.timeLab.attributedText = [NSString getAttributeString:time_str dealStr:model.dateline strAttributeDic:@{NSForegroundColorAttributeName : TEXT_COLOR}];
    
    if (model.pay_status == 0) {
        if (model.online_pay == 1) {
            
        }
        model.pay_code =  model.online_pay == 1 ? NSLocalizedString(@"未支付", NSStringFromClass([self class])) : NSLocalizedString(@"货到付款", NSStringFromClass([self class]));
    }
    NSString* pay_str = [NSString stringWithFormat:NSLocalizedString(@"支付方式: %@", NSStringFromClass([self class])),model.pay_code];
    self.payTypeLab.attributedText = [NSString getAttributeString:pay_str dealStr:model.pay_code strAttributeDic:@{NSForegroundColorAttributeName : TEXT_COLOR}];
    
    if (model.intro.length == 0) {
        model.intro =  NSLocalizedString(@"暂无备注", NSStringFromClass([self class]));
    }
    
    self.noteLab.attributedText = [NSString getParagraphStyleAttributeStr:model.intro lineSpacing:5.0];

}

@end

