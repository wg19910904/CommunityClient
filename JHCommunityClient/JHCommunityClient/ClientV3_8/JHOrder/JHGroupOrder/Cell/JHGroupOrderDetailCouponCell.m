//
//  JHGroupOrderDetailCouponCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderDetailCouponCell.h"

@interface JHGroupOrderDetailCouponCell()
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *couponCodeLab;
@property(nonatomic,weak)UILabel *statusLab;
@end

@implementation JHGroupOrderDetailCouponCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.offset=0;
        make.right.offset=0;
        make.height.offset=8;
    }];
    lineView.backgroundColor=BACKGROUND_COLOR;
    
    UILabel *lab = [UILabel new];
    [self.contentView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    lab.font = FONT(14);
    lab.textColor = HEX(@"9999999", 1.0);
    lab.text =  NSLocalizedString(@"团购券", NSStringFromClass([self class]));
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(lab.mas_centerY).offset(0);
        make.height.offset(20);
    }];
    timeLab.font = FONT(11);
    timeLab.textColor = HEX(@"999999", 1.0);
    self.timeLab = timeLab;
    
    UIView *mid_lineView=[UIView new];
    [self.contentView addSubview:mid_lineView];
    [mid_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.top.equalTo(lab.mas_bottom).offset(10).priority(1000);
        make.right.offset=0;
        make.height.offset=0.5;
    }];
    mid_lineView.backgroundColor=LINE_COLOR;
    
    UILabel *couponCodeLab = [UILabel new];
    [self.contentView addSubview:couponCodeLab];
    [couponCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mid_lineView.mas_top).offset(10);
        make.left.offset(20);
        make.height.offset(20);
        make.bottom.offset(-10).priority(900);
    }];
    couponCodeLab.font = FONT(14);
    couponCodeLab.textColor = HEX(@"333333", 1.0);
    self.couponCodeLab = couponCodeLab;
    
    UILabel *statusLab = [UILabel new];
    [self.contentView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(couponCodeLab.mas_centerY).offset(0);
        make.height.offset(20);
    }];
    statusLab.font = FONT(14);
    statusLab.textColor = HEX(@"333333", 1.0);
    self.statusLab = statusLab;
    
    
    
}

-(void)reloadCellWithModel:(JHGroupOrderModel *)model{
    
    self.timeLab.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"有效期至: ", NSStringFromClass([self class])),model.ticket_ltime];
    self.couponCodeLab.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"劵码: ", NSStringFromClass([self class])),model.ticket_number];
    
    if (model.ticket_status == 0) {
        self.statusLab.text =  NSLocalizedString(@"未消费", NSStringFromClass([self class]));
    }else if (model.ticket_status == 1) {
        self.statusLab.text = NSLocalizedString(@"已消费", NSStringFromClass([self class]));
    }else{
        self.statusLab.text = NSLocalizedString(@"退款成功", NSStringFromClass([self class]));
    }

}

@end
