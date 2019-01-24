//
//  JHWMDetailProductCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderDetailProductCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"

@interface JHWMOrderDetailProductCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *typeLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@end

@implementation JHWMOrderDetailProductCell

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
    iconImgView.clipsToBounds = YES;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.font = FONT(14);
    titleLab.textColor = TEXT_COLOR;
    self.titleLab = titleLab;
    
    UILabel *typeLab = [UILabel new];
    [self.contentView addSubview:typeLab];
    [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.height.offset(20);
        make.right.offset(-120);
    }];
    typeLab.lineBreakMode = NSLineBreakByTruncatingTail;
    typeLab.font = FONT(12);
    typeLab.textColor = HEX(@"666666", 1.0);
    self.typeLab = typeLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab.mas_centerY);
        make.height.offset(20);
        make.right.offset(-80);
    }];
    countLab.font = FONT(12);
    countLab.textColor = HEX(@"666666", 1.0);
    self.countLab = countLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab.mas_centerY);
        make.height.offset(20);
        make.right.offset(-10);
    }];
    priceLab.font = FONT(15);
    priceLab.textColor = HEX(@"333333", 1.0);
    self.priceLab = priceLab;
    
}

-(void)reloadCellWithModel:(NSDictionary *)product{

    [self.iconImgView sd_setImageWithURL:ImageUrl(product[@"product_photo"]) placeholderImage:DefaultImgViewImage];
    self.titleLab.text = product[@"product_name_simple"];
    self.typeLab.text = product[@"spec_name"];
    
    if ([product[@"spec_name"] length] == 0) {
        self.typeLab.hidden = YES;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset(10);
            make.centerY.equalTo(self.iconImgView.mas_centerY);
            make.height.offset(20);
            make.right.offset(-120);
        }];
    }else{
        self.typeLab.hidden = NO;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImgView.mas_right).offset(10);
            make.top.equalTo(self.iconImgView.mas_top);
            make.height.offset(20);
            make.right.offset(-120);
        }];
    }
    
    self.countLab.text = [NSString stringWithFormat:@"x%@",product[@"product_number"]];
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),product[@"product_price"]];
    self.priceLab.attributedText = [NSString getAttributeString:str dealStr: NSLocalizedString(@"¥", nil) strAttributeDic:@{NSFontAttributeName : FONT(12),NSForegroundColorAttributeName : HEX(@"666666", 1.0)}];
    
}


@end
