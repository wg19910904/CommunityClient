//
//  JHGroupOrderListCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderListCell.h"
#import <UIImageView+WebCache.h>

@interface JHGroupOrderListCell ()
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UILabel *priceLab;
@property(nonatomic,weak)UILabel *statusLab;
@end


@implementation JHGroupOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    UIImageView *iconView = [UIImageView new];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=15;
        make.top.offset=15;
        make.width.height.offset=80;
        make.bottom.offset(-15).priority(1000);
    }];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.clipsToBounds = YES;
    self.iconView = iconView;
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.top.equalTo(iconView.mas_top);
        make.right.offset(-40);
        make.height.offset(20);
    }];
    titleLab.font = FONT(16);
    titleLab.textColor = TEXT_COLOR;
    self.titleLab = titleLab;
    
    UILabel *timeLab = [UILabel new];
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.top.equalTo(titleLab.mas_bottom);
        make.right.offset(-40);
        make.height.offset(20);
    }];
    timeLab.font = FONT(14);
    timeLab.textColor = HEX(@"737373", 1.0);
    self.timeLab = timeLab;
    
    UILabel *countLab = [UILabel new];
    [self.contentView addSubview:countLab];
    [countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.top.equalTo(timeLab.mas_bottom);
        make.right.offset(-40);
        make.height.offset(20);
    }];
    countLab.font = FONT(14);
    countLab.textColor = HEX(@"737373", 1.0);
    self.countLab = countLab;
    
    UILabel *priceLab = [UILabel new];
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.top.equalTo(countLab.mas_bottom);
        make.right.offset(-40);
        make.height.offset(20);
    }];
    priceLab.font = FONT(14);
    priceLab.textColor = TEXT_COLOR;
    self.priceLab = priceLab;
    
    UILabel *statusLab = [UILabel new];
    [self.contentView addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_top);
        make.right.offset(-10);
        make.height.offset(20);
//        make.width.lessThanOrEqualTo(@50);
    }];
    statusLab.font = FONT(14);
    statusLab.textColor = Orange_COLOR;
    self.statusLab = statusLab;
   
}

#pragma mark ====== Functions =======
-(void)reloadCellWithModel:(JHGroupOrderModel *)model{
   
    [self.iconView sd_setImageWithURL:ImageUrl(model.tuan_photo) placeholderImage:DefaultImgViewImage];
    self.titleLab.text = model.tuan_title;
    
    self.timeLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"有效期至: ", NSStringFromClass([self class])),model.tuan_ltime];
    self.countLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"数量: ", NSStringFromClass([self class])),model.tuan_number];
    self.priceLab.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"总价: ¥", NSStringFromClass([self class])),model.total_price];
    self.statusLab.text = model.order_status_label;

}

@end
