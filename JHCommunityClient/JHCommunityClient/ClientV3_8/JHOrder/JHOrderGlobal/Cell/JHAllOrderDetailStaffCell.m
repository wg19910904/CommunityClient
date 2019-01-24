//
//  JHAllOrderDetailStaffCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHAllOrderDetailStaffCell.h"
#import "YFTypeBtn.h"
#import <UIImageView+WebCache.h>

@interface JHAllOrderDetailStaffCell ()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *nameLab;
@property(nonatomic,weak)UILabel *sendTypeLab;
@end

@implementation JHAllOrderDetailStaffCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIImageView *iconImgView = [UIImageView new];
    [self.contentView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.width.height.offset(40);
        make.bottom.offset(-10);
    }];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.layer.cornerRadius=20;
    iconImgView.clipsToBounds=YES;
    self.iconImgView = iconImgView;
    
    UILabel *nameLab = [UILabel new];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(15);
        make.top.equalTo(iconImgView.mas_top);
        make.height.offset(18);
        make.right.offset(-100);
    }];
    nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    nameLab.font = FONT(14);
    nameLab.textColor = HEX(@"666666", 1.0);
    self.nameLab = nameLab;
    
    UILabel *sendTypeLab = [UILabel new];
    [self.contentView addSubview:sendTypeLab];
    [sendTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(15);
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.height.offset(18);
        make.width.greaterThanOrEqualTo(@70);
    }];
    sendTypeLab.layer.cornerRadius=4;
    sendTypeLab.clipsToBounds=YES;
    sendTypeLab.backgroundColor = Orange_COLOR;
    sendTypeLab.font = FONT(12);
    sendTypeLab.textAlignment = NSTextAlignmentCenter;
    sendTypeLab.textColor = HEX(@"ffffff", 1.0);
    self.sendTypeLab = sendTypeLab;
    
    YFTypeBtn *callBtn = [YFTypeBtn new];
    [self.contentView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(iconImgView.mas_centerY);
        make.width.greaterThanOrEqualTo(@70);
        make.height.offset(40);
    }];
    callBtn.btnType = LeftImage;
    callBtn.titleMargin = 5;
    callBtn.titleLabel.font = FONT(13);
    [callBtn setImage:IMAGE(@"wm_order_phone") forState:UIControlStateNormal];
    [callBtn setTitleColor:HEX(@"333333", 1.0) forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(clickStaffPhone) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setTitle: NSLocalizedString(@"联系骑手", NSStringFromClass([self class])) forState:UIControlStateNormal];
    
    
}

-(void)clickStaffPhone{
    YF_SAFE_BLOCK(self.clickCallBlock,NO,@"");
}

-(void)reloadCellWithModel:(JHWaiMaiModel *)model{
    
    [self.iconImgView sd_setImageWithURL:ImageUrl(model.staff[@"face"]) placeholderImage:IMAGE(@"loginheader")];
    self.nameLab.text = model.staff[@"name"];
    
    NSString *pei_type =  NSLocalizedString(@"商家配送", NSStringFromClass([self class]));
    if ([model.pei_type isEqualToString:@"1"]) pei_type =  NSLocalizedString(@"平台配送", NSStringFromClass([self class]));
    self.sendTypeLab.text = pei_type;
}

@end
