//
//  JHGroupOrderDetailProductCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderDetailProductCell.h"
#import "YFTypeBtn.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"

@interface JHGroupOrderDetailProductCell()
@property(nonatomic,weak)UIImageView *iconImgView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)YFTypeBtn *tuiBtn_anyTime;// 随时退
@property(nonatomic,weak)YFTypeBtn *tuiBtn_outTime;// 过期退
@end

@implementation JHGroupOrderDetailProductCell

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
        make.left.top.offset(20);
        make.width.height.offset(50);
    }];
    iconImgView.clipsToBounds = YES;
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImgView = iconImgView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.top.equalTo(iconImgView.mas_top);
        make.width.right.offset(-40);
        make.height.offset=20;
    }];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.font = FONT(13);
    titleLab.textColor = HEX(@"333333", 1.0);
    self.titleLab = titleLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.bottom.equalTo(iconImgView.mas_bottom);
        make.width.right.offset(-40);
        make.height.offset=20;
    }];
    priceLab.lineBreakMode = NSLineBreakByTruncatingTail;
    priceLab.font = FONT(18);
    priceLab.textColor = Orange_COLOR;
    self.priceLab = priceLab;
    
    UIImageView *arrowImgView = [UIImageView new];
    [self addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImgView.mas_centerY);
        make.right.offset(-10);
        make.width.height.offset(30);
    }];
    arrowImgView.contentMode = UIViewContentModeCenter;
    arrowImgView.image = IMAGE(@"arrowR");
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(iconImgView.mas_bottom).offset(20);
        make.height.offset=0.5;
        make.bottom.offset(-40);
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    YFTypeBtn *tuiBtn_anyTime = [YFTypeBtn new];
    [self.contentView addSubview:tuiBtn_anyTime];
    [tuiBtn_anyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.height.offset(20);
    }];
    tuiBtn_anyTime.btnType = LeftImage;
    tuiBtn_anyTime.titleMargin = 5;
    tuiBtn_anyTime.titleLabel.font = FONT(12);
    [tuiBtn_anyTime setImage:IMAGE(@"icon-select-click") forState:UIControlStateNormal];
    [tuiBtn_anyTime setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    [tuiBtn_anyTime setTitle: NSLocalizedString(@"随时退", NSStringFromClass([self class])) forState:UIControlStateNormal];
    self.tuiBtn_anyTime = tuiBtn_anyTime;
    
    YFTypeBtn *tuiBtn_outTime = [YFTypeBtn new];
    [self.contentView addSubview:tuiBtn_outTime];
    [tuiBtn_outTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tuiBtn_anyTime.mas_right).offset(20);
        make.centerY.equalTo(tuiBtn_anyTime.mas_centerY);
        make.height.offset(20);
    }];
    tuiBtn_outTime.btnType = LeftImage;
    tuiBtn_outTime.titleMargin = 5;
    tuiBtn_outTime.titleLabel.font = FONT(12);
    [tuiBtn_outTime setImage:IMAGE(@"icon-select-click") forState:UIControlStateNormal];
    [tuiBtn_outTime setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    [tuiBtn_outTime setTitle: NSLocalizedString(@"过期退", NSStringFromClass([self class])) forState:UIControlStateNormal];
    self.tuiBtn_outTime = tuiBtn_outTime;
    
}

-(void)reloadCellWithModel:(JHGroupOrderModel *)model{
    
    [self.iconImgView sd_setImageWithURL:ImageUrl(model.tuan_photo) placeholderImage:DefaultImgViewImage];
    self.titleLab.text = model.tuan_title;
    NSString *str1 = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", nil),model.tuan_price];
    NSString *str2 = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"门市价 ¥", nil),model.price];
    NSString *str = [NSString stringWithFormat:@"%@  %@",str1,str2];
    self.priceLab.attributedText = [NSString getAttributeString:str dealStr:str2 strAttributeDic:  @{NSForegroundColorAttributeName : HEX(@"666666", 1.0),NSFontAttributeName : FONT(12)}];
    
}

@end
