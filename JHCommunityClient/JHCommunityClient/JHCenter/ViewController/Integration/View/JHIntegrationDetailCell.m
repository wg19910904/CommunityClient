//
//  JHIntegrationDetailCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationDetailCell.h"

@implementation JHIntegrationDetailCell
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
    UILabel *title = [UILabel new];
    title.font = FONT(14);
    title.text = NSLocalizedString(@"订单详情", nil);
    title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 40;
    }];
    
    _orderID = [UILabel new];
    _orderID.font = FONT(14);
    
    _orderID.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_orderID];
    [_orderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.equalTo(title.mas_bottom).offset = 0;
        make.height.offset = 40;
    }];
    
    _contact = [UILabel new];
    _contact.font = FONT(14);
   
    _contact.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_contact];
    [_contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.equalTo(_orderID.mas_bottom).offset = 0;
        make.height.offset = 40;
    }];
    
    _addr = [UILabel new];
    _addr.font = FONT(14);
   
    _addr.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_addr];
    [_addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.equalTo(_contact.mas_bottom).offset = 0;
        make.height.offset = 40;
    }];
    
    _payType = [UILabel new];
    
    _payType.font = FONT(14);
    _payType.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_payType];
    [_payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 10;
        make.right.offset = 0;
        make.top.equalTo(_addr.mas_bottom).offset = 0;
        make.height.offset = 40;
    }];
    
    for(int i = 0;i < 6; i ++){
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:line];
        if(i == 0){
            line.frame = FRAME(0, 0, WIDTH, 0.5);
        }else{
             line.frame = FRAME(0, 40 * i - 0.5, WIDTH, 0.5);
        }
    }
}
- (void)setDetailModel:(JHIntegrationOrderListModel *)detailModel{
    _detailModel = detailModel;
    _orderID.text = [NSString stringWithFormat:NSLocalizedString(@"订单号:%@", nil),_detailModel.order_id];
     _contact.text = [NSString stringWithFormat:NSLocalizedString(@"联系人:%@", nil),_detailModel.contact];
     _addr.text = [NSString stringWithFormat:NSLocalizedString(@"联系地址:%@%@", nil),_detailModel.addr,_detailModel.house];
    NSString *payType = nil;
    if([_detailModel.pay_code isEqualToString:@"wxpay"]){
        payType = NSLocalizedString(@"微信支付", nil);
    }else if([_detailModel.pay_code isEqualToString:@"alipay"]){
         payType = NSLocalizedString(@"支付宝支付", nil);
    }else if([_detailModel.pay_code isEqualToString:@"money"]){
         payType = NSLocalizedString(@"余额支付", nil);
    }else{
         payType = NSLocalizedString(@"未支付", nil);
    }
    _payType.text = [NSString stringWithFormat:NSLocalizedString(@"支付方式:%@", nil),payType];
}
@end
