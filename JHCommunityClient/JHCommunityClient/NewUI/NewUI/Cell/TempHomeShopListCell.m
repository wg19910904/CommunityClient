//
//  TempHomeShopListCell.m
//  JHCommunityClient
//
//  Created by ijianghu on 2018/4/12.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "TempHomeShopListCell.h"
#import <UIImageView+WebCache.h>
#import "StarView.h"

@interface TempHomeShopListCell(){
    UIImageView *imageV;//店铺照片
    UILabel *shopNameL;//店铺名称
    UILabel *moneyL;//起送价
    UILabel *addrL;//地址Label
    UIImageView * addrImgV;//定位图片
    UILabel *distanceL;//距离Label
    UILabel *scoreL;//评分和已售Label
    
}
@property(nonatomic,weak)UIView *starView;

@end

@implementation TempHomeShopListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatUI{
//    self.backgroundColor = HEX(@"f5f5f5", 1);
    imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 15;
        make.height.width.offset = 70;
    }];
    imageV.layer.cornerRadius = 4;
    imageV.layer.masksToBounds = YES;
    
    shopNameL = [[UILabel alloc]init];
    [self addSubview:shopNameL];
    [shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top);
        make.left.equalTo(imageV.mas_right).offset = 10;
        make.width.offset = 150;
        make.height.offset = 20;
    }];
    shopNameL.text = NSLocalizedString(@"临时店名",nil);
    shopNameL.font  = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    shopNameL.textColor = RGBA(51, 51, 51, 1.0);
    
    moneyL = [[UILabel alloc]init];
    [self addSubview:moneyL];
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top);
        make.right.offset =-10;
        make.width.offset = 100;
        make.height.offset = 20;
    }];
    moneyL.textColor = [UIColor redColor];
    moneyL.textAlignment =NSTextAlignmentRight;
//    moneyL.text = NSLocalizedString(@"80元起",nil);
    moneyL.font = FONT(15);
    
    addrImgV = [[UIImageView alloc]init];
    [self addSubview:addrImgV];
    [addrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopNameL.mas_bottom).offset =10;
        make.left.equalTo(shopNameL.mas_left);
        make.width.offset =10;
        make.height.offset = 13;
    }];
    addrImgV.image = [UIImage imageNamed:@"nearby"];
    
    addrL = [[UILabel alloc]init];
    [self addSubview:addrL];
    [addrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopNameL.mas_bottom).offset =5;
        make.left.equalTo(addrImgV.mas_right).offset = 5;
        make.right.offset =-80;
        make.height.offset = 20;
    }];
//    addrL.text =GLOBAL(@"hahahhahahahahahhaha");
    addrL.textColor = HEX(@"666666", 1);
    addrL.font = FONT(14);
    
    distanceL = [[UILabel alloc]init];
    [self addSubview:distanceL];
    [distanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopNameL.mas_bottom).offset =5;
        make.right.offset =-10;
        make.width.offset =50;
        make.height.offset = 20;
    }];
//    distanceL.text =GLOBAL(@"12.3km");
    distanceL.textColor = HEX(@"666666", 1);
    distanceL.font = FONT(14);
    distanceL.textAlignment =NSTextAlignmentRight;
    
    
    scoreL = [[UILabel alloc]init];
    [self addSubview:scoreL];
    [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrL.mas_bottom).offset = 5;
        make.left.equalTo(shopNameL.mas_left);
        make.width.offset = 60;
        make.height.offset = 20;
    }];
//    scoreL.text = GLOBAL(@"评分4.5");
    scoreL.font  = FONT(14);
    scoreL.textColor = HEX(@"999999", 1);
    
    UIView *starView = [StarView addEvaluateViewWithStarNO:0.0 withStarSize:10 withBackViewFrame:CGRectMake(150, 65, 60, 20)];
    [self.contentView addSubview:starView];
    self.starView = starView;
    
    
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.bottom.offset = -1;
        make.height.offset = 1;
    }];
    line.backgroundColor = HEX(@"e6e6e6", 1);
    
    
}
- (void)setModel:(WaiMaiShopperModel *)model{
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:PHAIMAGE];
    shopNameL.text = model.title;
//    moneyL.text = ;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString(@"人均¥%@",nil),model.avg_amount]];
    NSRange range1=[[hintString string]rangeOfString:@"人均¥"];
       NSRange range2=[[hintString string]rangeOfString:@"人均"];
    [hintString addAttribute:NSFontAttributeName value:FONT(12) range:range1];
     [hintString addAttribute:NSForegroundColorAttributeName value:HEX(@"4d4d4d", 1) range:range2];
    moneyL.attributedText = hintString;
    
    addrL.text = model.addr;
    distanceL.text = model.juli_label;
    scoreL.text = [NSString stringWithFormat:NSLocalizedString(@"评分%@ ",nil),model.avg_score];
    if (self.starView) {
        [self.starView removeFromSuperview];
        UIView *starView = [StarView addEvaluateViewWithStarNO:[model.avg_score floatValue] withStarSize:10 withBackViewFrame:CGRectMake(150, 65, 60, 20)];

        [self.contentView addSubview:starView];
        self.starView = starView;
    }
}
@end
