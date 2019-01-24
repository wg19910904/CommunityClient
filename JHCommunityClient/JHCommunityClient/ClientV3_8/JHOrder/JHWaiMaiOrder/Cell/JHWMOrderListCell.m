//
//  JHWaiMaiListCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderListCell.h"
#import "NSString+Tool.h"
#import <UIImageView+WebCache.h>

@interface JHWMOrderListCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *zitiLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *productLab;
@property(nonatomic,weak)UILabel *priceLab;
@end


@implementation JHWMOrderListCell

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
        make.left.offset(12);
        make.top.offset(15);
        make.width.height.offset(40);
        make.bottom.offset(-15);
    }];
    iconImgView.clipsToBounds = YES;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImgView = iconImgView;
    
    UILabel *zitiLab = [UILabel new];
    [self.contentView addSubview:zitiLab];
    [zitiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.top.equalTo(iconImgView.mas_top);
        make.height.offset(20);
        make.width.greaterThanOrEqualTo(@35);
    }];
    zitiLab.layer.cornerRadius=5;
    zitiLab.clipsToBounds=YES;
    zitiLab.backgroundColor = Orange_COLOR;
    zitiLab.textColor = [UIColor whiteColor];
    zitiLab.font = FONT(12);
    zitiLab.textAlignment = NSTextAlignmentCenter;
    zitiLab.text =  NSLocalizedString(@"自提", NSStringFromClass([self class]));
    self.zitiLab = zitiLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zitiLab.mas_right).offset(10);
        make.centerY.equalTo(zitiLab.mas_centerY);
        make.height.offset(20);
    }];
    timeLab.font = FONT(11);
    timeLab.textColor = HEX(@"999999", 1.0);
    self.timeLab = timeLab;
    
    UILabel *productLab = [UILabel new];
    [self.contentView addSubview:productLab];
    [productLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.height.offset(20);
        make.right.offset(-100);
    }];
    productLab.font = FONT(14);
    productLab.textColor = HEX(@"666666", 1.0);
    productLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.productLab = productLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(productLab.mas_centerY);
        make.height.offset(20);
        make.right.offset(-13);
    }];
    priceLab.font = FONT(14);
    priceLab.textColor = HEX(@"4d4d4d", 1.0);
    self.priceLab = priceLab;
  
}

-(void)reloadCellWithModel:(JHWaiMaiModel *)model{

    [self.iconImgView sd_setImageWithURL:ImageUrl(model.shop_logo) placeholderImage:DefaultImgViewImage];
    self.timeLab.text = model.dateline;
    self.productLab.text = model.product_title;
    NSString *prefixStr = model.pay_status == 0 ? NSLocalizedString(@"需付: ¥", NSStringFromClass([self class])) : NSLocalizedString(@"实付: ¥", NSStringFromClass([self class]));
    NSString *str = [NSString stringWithFormat:@"%@%@",prefixStr,model.real_pay];
    NSAttributedString * attStr = [NSString getAttributeString:str dealStr: NSLocalizedString(@"¥", nil) strAttributeDic:@{NSFontAttributeName : FONT(12),NSForegroundColorAttributeName : HEX(@"ff0000", 1.0)}];
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attStr];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:HEX(@"ff0000", 1.0) range:NSMakeRange(attStr.length-model.real_pay.length, model.real_pay.length)];
    self.priceLab.attributedText = muAttStr.copy;
    
    self.zitiLab.hidden = YES;
    if ([model.pei_type isEqualToString:@"3"] || [model.pei_type isEqualToString:@"4"]) {
        self.zitiLab.hidden = NO;
        self.zitiLab.text = [model.pei_type isEqualToString:@"3"] ?  NSLocalizedString(@"自提", nil) :  NSLocalizedString(@"堂食", nil);
        [self.zitiLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(35);
        }];
        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.zitiLab.mas_right).offset(10);
        }];
    }else{
        [self.zitiLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
        }];
        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.zitiLab.mas_right);
        }];
    }
    
}

@end
