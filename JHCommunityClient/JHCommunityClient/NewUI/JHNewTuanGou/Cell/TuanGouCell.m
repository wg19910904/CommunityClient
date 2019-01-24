//
//  TuanGouCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 17/3/28.
//  Copyright © 2017年 JiangHu. All rights reserved.
//

#import "TuanGouCell.h"
#import <UIImageView+WebCache.h>

@interface TuanGouCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *distanceLab;
@property(nonatomic,weak)UILabel *juanLab;// 区和团购卷
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *countLab;
@end

@implementation TuanGouCell

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
        make.left.offset=10;
        make.top.offset=10;
        make.width.offset=80;
        make.height.offset=80;
    }];
    iconImgView.layer.cornerRadius=4;
    iconImgView.clipsToBounds=YES;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=100;
        make.top.offset=10;
        make.right.offset = -30;
        make.height.offset=20;
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"222222", 1.0);
    self.titleLab = titleLab;
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UILabel *juanLab = [UILabel new];
    [self.contentView addSubview:juanLab];
    [juanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=100;
        make.top.equalTo(titleLab.mas_bottom).offset=10;
        make.right.offset=-10;
        make.height.offset=20;
    }];
    juanLab.lineBreakMode = NSLineBreakByTruncatingTail;
    juanLab.font = FONT(12);
    juanLab.textColor = HEX(@"999999", 1.0);
    self.juanLab = juanLab;
    
    UILabel *distanceLab = [UILabel new];
    [self.contentView addSubview:distanceLab];
    [distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.bottom.equalTo(juanLab.mas_top).offset=0;
        make.height.offset=15;
    }];
    distanceLab.font = FONT(12);
    distanceLab.textColor = HEX(@"999999", 1.0);
    self.distanceLab = distanceLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=100;
        make.top.equalTo(juanLab.mas_bottom).offset=10;
        make.height.offset=20;
    }];
    priceLab.textColor = THEME_COLOR;
    priceLab.font = FONT(14);
    self.priceLab = priceLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-10;
        make.centerY.equalTo(priceLab.mas_centerY).offset=0;
        make.height.offset=20;
    }];
    countLab.font = FONT(12);
    countLab.textColor = HEX(@"999999", 1.0);
    self.countLab = countLab;
    
}

-(void)reloadCellWithModel:(TuanGouModel *)model{
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:IMAGE(@"defaultimg")];
    self.titleLab.text = @"";
    self.distanceLab.text = @"";
    self.juanLab.text = @"";
    self.countLab.text = @"";
    self.priceLab.attributedText = [self getAttStrNewPrice:@"96" oldPrice:@"116"];
    
}

-(NSMutableAttributedString *)getAttStrNewPrice:(NSString *)newPrice oldPrice:(NSString *)oldPrice{
    NSString * str = [NSString stringWithFormat:@"¥%@ ¥%@",newPrice,oldPrice];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:FONT(12) range:NSMakeRange(str.length-oldPrice.length-1, oldPrice.length+1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:HEX(@"999999", 1.0) range:NSMakeRange(str.length-oldPrice.length-1, oldPrice.length+1)];
    [attStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str.length-oldPrice.length-1, oldPrice.length+1)];
    
    return attStr;
}

@end
