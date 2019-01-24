//
//  JHGroupOrderDetailShopCell.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHGroupOrderDetailShopCell.h"
#import "YFTypeBtn.h"

@interface JHGroupOrderDetailShopCell()
@property(nonatomic,weak)UILabel *titleLab;
@property(nonatomic,weak)UILabel *addresLab;
@property(nonatomic,weak)YFTypeBtn *distanceBtn;
@end

@implementation JHGroupOrderDetailShopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(10);
        make.height.offset(20);
        make.right.offset(-130);
    }];
    titleLab.font = FONT(14);
    titleLab.textColor = HEX(@"333333", 1.0);
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLab = titleLab;
    
    UILabel *addresLab = [UILabel new];
    [self.contentView addSubview:addresLab];
    [addresLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(titleLab.mas_bottom);
        make.height.offset(20);
        make.right.offset(-130);
        make.bottom.offset(-10).priority(900);
    }];
    addresLab.font = FONT(11);
    addresLab.textColor = HEX(@"999999", 1.0);
    addresLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.addresLab = addresLab;

    
    UIButton *callBtn = [UIButton new];
    [self.contentView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.offset(0);
        make.width.height.offset(30);
    }];
    [callBtn setImage:IMAGE(@"tuan_order_phone") forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(callBtn.mas_left).offset(-15);
        make.centerY.offset(0);
        make.width.offset(1);
        make.height.offset(20);
    }];
    lineView.backgroundColor=LINE_COLOR;
    
    YFTypeBtn *distanceBtn = [YFTypeBtn new];
    [self.contentView addSubview:distanceBtn];
    [distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lineView.mas_left).offset(-15);
        make.centerY.offset(0);
        make.height.offset(30);
    }];
    distanceBtn.titleLabel.font = FONT(12);
    [distanceBtn setTitleColor:HEX(@"666666", 1.0) forState:UIControlStateNormal];
    [distanceBtn setImage:IMAGE(@"order_location") forState:UIControlStateNormal];
    distanceBtn.btnType = LeftImage;
    distanceBtn.titleMargin = 5;
    self.distanceBtn = distanceBtn;
    
    UIButton *cover_btn = [UIButton new];
    [self.contentView addSubview:cover_btn];
    [cover_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.equalTo(lineView.mas_left);
    }];
    [cover_btn addTarget:self action:@selector(clickGoShop) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickGoShop{
    YF_SAFE_BLOCK(self.goShopDetail,NO,@"");
}

-(void)clickCallBtn{
    YF_SAFE_BLOCK(self.telCallblock,NO,@"");
}

-(void)reloadCellWithModel:(JHGroupOrderModel *)model{
    self.titleLab.text = model.shop_title;
    self.addresLab.text = model.shop_addr;
    [self.distanceBtn setTitle:model.juli_label forState:UIControlStateNormal];
}

@end
