//
//  JHPayBillDetailCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayBillDetailCell.h"

@implementation JHPayBillDetailCell
{
    UIView *_topLine;
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
    
    _houseName1 = [UILabel new];
    _houseName1.font = FONT(14);
    _houseName1.textColor = HEX(@"686868", 1.0f);
    _houseName1.text = NSLocalizedString(@"户名:", nil);
    [self.contentView addSubview:_houseName1];
    [_houseName1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 15;
        make.height.offset = 15;
        make.width.offset = 60;
    }];
    
    _houseName = [UILabel new];
    _houseName.font = FONT(14);
    _houseName.textColor = HEX(@"686868", 1.0f);
    _houseName.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_houseName];
    [_houseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(_houseName1);
        make.left.equalTo(_houseName1.mas_right).offset = 10;
        make.height.offset = 15;
    }];
    
    _houseHold1 = [UILabel new];
    _houseHold1.textColor = HEX(@"686868", 1.0f);
    _houseHold1.font = FONT(14);
    _houseHold1.text = NSLocalizedString(@"缴费户名:", nil);
    [self.contentView addSubview:_houseHold1];
    [_houseHold1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(_houseName1.mas_bottom).offset = 15;
        make.height.offset = 15;
        make.width.offset = 80;
    }];
    
    _houseHold = [UILabel new];
    _houseHold.font = FONT(14);
    _houseHold.textColor = HEX(@"686868", 1.0f);
    _houseHold.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_houseHold];
    [_houseHold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(_houseHold1);
        make.left.equalTo(_houseHold1.mas_right).offset = 10;
        make.height.offset = 15;
    }];
    
    _unitName1 = [UILabel new];
    _unitName1.textColor = HEX(@"686868", 1.0f);
    _unitName1.font = FONT(14);
    _unitName1.text = NSLocalizedString(@"缴费单位:", nil);
    [self.contentView addSubview:_unitName1];
    [_unitName1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.equalTo(_houseHold1.mas_bottom).offset = 15;
        make.height.offset = 15;
        make.width.offset = 80;
    }];
    _unitName = [UILabel new];
    _unitName.font = FONT(14);
    _unitName.textColor = HEX(@"686868", 1.0f);
    _unitName.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_unitName];
    [_unitName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.centerY.equalTo(_unitName1);
        make.left.equalTo(_unitName1.mas_right).offset = 10;
        make.height.offset = 15;
    }];
    
    _tenementFee1 = [UILabel new];
    _tenementFee1.textColor = HEX(@"686868", 1.0f);
    _tenementFee1.font = FONT(14);
    _tenementFee1.text = NSLocalizedString(@"本次物业费:", nil);
    [self.contentView addSubview:_tenementFee1];
    
    
    _tenementFee = [UILabel new];
    _tenementFee.textColor = HEX(@"686868", 1.0f);
    _tenementFee.font = FONT(14);
    _tenementFee.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_tenementFee];
    
    
    _waterFee1 = [UILabel new];
    _waterFee1.textColor = HEX(@"686868", 1.0f);
    _waterFee1.font = FONT(14);
    _waterFee1.text = NSLocalizedString(@"本次水费:", nil);
    [self.contentView addSubview:_waterFee1];
    
    _waterFee = [UILabel new];
    _waterFee.textColor = HEX(@"686868", 1.0f);
    _waterFee.font = FONT(14);
    _waterFee.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_waterFee];
    
    _electricCharge1 = [UILabel new];
    _electricCharge1.textColor = HEX(@"686868", 1.0f);
    _electricCharge1.font = FONT(14);
    _electricCharge1.text = NSLocalizedString(@"本次电费:", nil);
    [self.contentView addSubview:_electricCharge1];
    
    
    _electricCharge = [UILabel new];
    _electricCharge.textColor = HEX(@"686868", 1.0f);
    _electricCharge.font = FONT(14);
    _electricCharge.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_electricCharge];
  
    _gasFee1 = [UILabel new];
    _gasFee1.textColor = HEX(@"686868", 1.0f);
    _gasFee1.font = FONT(14);
    _gasFee1.text = NSLocalizedString(@"本次燃气费:", nil);
    [self.contentView addSubview:_gasFee1];
 
    _gasFee = [UILabel new];
    _gasFee.textColor = HEX(@"686868", 1.0f);
    _gasFee.font = FONT(14);
    _gasFee.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_gasFee];
 
    
    _cheWeiFee1 = [UILabel new];
    _cheWeiFee1.textColor = HEX(@"686868", 1.0f);
    _cheWeiFee1.font = FONT(14);
    _cheWeiFee1.text = NSLocalizedString(@"本次车位费:", nil);
    [self.contentView addSubview:_cheWeiFee1];
    
    _cheWeiFee = [UILabel new];
    _cheWeiFee.textColor = HEX(@"686868", 1.0f);
    _cheWeiFee.font = FONT(14);
    _cheWeiFee.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_cheWeiFee];
    
    _topLine = [UIView new];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
    _topLine.backgroundColor = LINE_COLOR;
    
    _totalView = [UIView new];
    _totalView.backgroundColor = [UIColor whiteColor];
    _totalView.layer.borderColor = LINE_COLOR.CGColor;
    _totalView.layer.borderWidth = 0.5f;
    _totalView.clipsToBounds = YES;
    [self.contentView addSubview:_totalView];
    
    _totalFee = [UILabel new];
    _totalFee.textColor = HEX(@"686868", 1.0f);
    _totalFee.textAlignment = NSTextAlignmentCenter;
   
    _totalFee.font = FONT(14);
    [_totalView addSubview:_totalFee];
    [_totalFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 34;
        make.right.offset = 0;
        make.height.offset = 40;
        make.top.offset = 0;
    }];
    
    _money = [UILabel new];
    _money.font = FONT(14);
    _money.textAlignment = NSTextAlignmentCenter;
    _money.textColor = HEX(@"686868", 1.0f);
    _money.text = @"¥";
    [_totalView addSubview:_money];
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.size.mas_equalTo(CGSizeMake(34, 40));
        make.top.offset = 0;
    }];
    UIView *middleLine = [UIView new];
    [_totalView addSubview:middleLine];
    middleLine.backgroundColor = LINE_COLOR;
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_money.mas_right).offset = 0;
        make.width.offset = 0.5;
        make.height.offset = 40;
        make.top.offset = 0;
    }];
}
- (void)setPayFeeBillDetailFrameModel:(JHPayFeeBillDetailFrameModel *)payFeeBillDetailFrameModel{
    _payFeeBillDetailFrameModel = payFeeBillDetailFrameModel;
    _houseName.text = payFeeBillDetailFrameModel.payFeeBillListModel.yezhu_name;
    _houseHold.text = payFeeBillDetailFrameModel.payFeeBillListModel.yezhu_house;
    _unitName.text = payFeeBillDetailFrameModel.payFeeBillListModel.wuye_name;
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.wuye_price floatValue] >0){
        //物业费
        _tenementFee.hidden = NO;
        _tenementFee1.hidden = NO;
        _tenementFee1.frame = FRAME(15, _payFeeBillDetailFrameModel.wuYeFeeHeight, 120, 15);
        _tenementFee.frame = FRAME(15 + 130, _payFeeBillDetailFrameModel.wuYeFeeHeight, WIDTH - 160, 15);
        _tenementFee.text = [NSString stringWithFormat:@"%@元",payFeeBillDetailFrameModel.payFeeBillListModel.wuye_price];
    }else{
        _tenementFee.hidden = YES;
        _tenementFee1.hidden = YES;
    }
   
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.shui_price floatValue] > 0){
        //水费
        _waterFee.hidden = NO;
        _waterFee1.hidden = NO;
        _waterFee1.frame = FRAME(15, _payFeeBillDetailFrameModel.waterFeeHeight, 80, 15);
        _waterFee.frame = FRAME(15 + 90, _payFeeBillDetailFrameModel.waterFeeHeight, WIDTH - 120, 15);
        _waterFee.text = [NSString stringWithFormat:@"%@元",payFeeBillDetailFrameModel.payFeeBillListModel.shui_price];

    }else{
        _waterFee1.hidden = YES;
        _waterFee.hidden = YES;
    }
    
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.dian_price floatValue] > 0){
        //电费
        _electricCharge.hidden = NO;
        _electricCharge1.hidden = NO;
        _electricCharge1.frame = FRAME(15, _payFeeBillDetailFrameModel.dianFeeHeight, 80, 15);
        _electricCharge.frame = FRAME(15 + 90, _payFeeBillDetailFrameModel.dianFeeHeight, WIDTH - 120, 15);
        _electricCharge.text = [NSString stringWithFormat:@"%@元",_payFeeBillDetailFrameModel.payFeeBillListModel.dian_price] ;
    }else{
        _electricCharge.hidden = YES;
        _electricCharge1.hidden = YES;
    }
   
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.ranqi_price floatValue] > 0){
        //燃气费
        _gasFee.hidden = NO;
        _gasFee.hidden = NO;
        _gasFee1.frame = FRAME(15, _payFeeBillDetailFrameModel.gasFeeHeight, 120, 15);
        _gasFee.frame = FRAME(15 + 130, _payFeeBillDetailFrameModel.gasFeeHeight, WIDTH - 160, 15);
        _gasFee.text = [NSString stringWithFormat:@"%@元",_payFeeBillDetailFrameModel.payFeeBillListModel.ranqi_price];
    }else{
        _gasFee.hidden = YES;
        _gasFee.hidden = YES;
    }
    
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.chewei_price floatValue] > 0){
        //车位费
        _cheWeiFee.hidden = NO;
        _cheWeiFee1.hidden = NO;
        _cheWeiFee1.frame = FRAME(15, _payFeeBillDetailFrameModel.cheWeiHeight, 120, 15);
        _cheWeiFee.frame = FRAME(15 + 130, _payFeeBillDetailFrameModel.cheWeiHeight, WIDTH - 160, 15);
        _cheWeiFee.text = [NSString stringWithFormat:@"%@元",_payFeeBillDetailFrameModel.payFeeBillListModel.chewei_price];
    }else{
        _cheWeiFee.hidden = YES;
        _cheWeiFee1.hidden = YES;
    }
    
    if([_payFeeBillDetailFrameModel.payFeeBillListModel.pay_status isEqualToString:@"0"]){
        //总价
        _totalView.hidden = NO;
        _totalView.frame = FRAME(15, _payFeeBillDetailFrameModel.totalViewHeight, WIDTH - 15, 40);
        _totalFee.text = _payFeeBillDetailFrameModel.payFeeBillListModel.total_price;
    }else{
        _totalView.hidden = YES;
    }
}
@end
