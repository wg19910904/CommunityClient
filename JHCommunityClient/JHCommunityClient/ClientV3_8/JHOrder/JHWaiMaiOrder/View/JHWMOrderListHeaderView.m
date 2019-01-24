//
//  JHWMOrderListHeaderView.m
//  JHCommunityClient
//
//  Created by ios_yangfei on 2018/5/22.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHWMOrderListHeaderView.h"
#import "YFTypeBtn.h"

@interface JHWMOrderListHeaderView ()
@property(nonatomic,weak)YFTypeBtn *titleBtn;
@property(nonatomic,weak)UILabel *statusLab;
@property(nonatomic,weak)UIButton *locationBtn;
@property(nonatomic,copy)NSString *shop_id;
@end

@implementation JHWMOrderListHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *btn = [UIButton new];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.bottom.left.offset(0);
    }];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(clickShop) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *iconImgView = [UIImageView new];
    [btn addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.width.height.offset(20);
    }];
    iconImgView.image = IMAGE(@"maidanshop");
    
    YFTypeBtn *titleBtn = [YFTypeBtn new];
    [btn addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView.mas_right).offset(10);
        make.centerY.offset(0);
        make.height.offset(20);
    }];
    titleBtn.titleLabel.font = FONT(15);
    titleBtn.btnType = RightImage;
    titleBtn.imageMargin = 10;
    [titleBtn setImage:IMAGE(@"arrowR") forState:UIControlStateNormal];
    [titleBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
    titleBtn.userInteractionEnabled = NO;
    self.titleBtn = titleBtn;
    
    UILabel *statusLab = [UILabel new];
    [btn addSubview:statusLab];
    [statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-13);
        make.centerY.equalTo(iconImgView.mas_centerY);
        make.height.offset(20);
    }];
    statusLab.font = FONT(14);
    statusLab.textColor = Orange_COLOR;
    self.statusLab = statusLab;
    
    UIButton *locationBtn = [UIButton new];
    [btn addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.centerY.equalTo(iconImgView.mas_centerY);
        make.top.bottom.offset(0);
        make.width.greaterThanOrEqualTo(@65);
    }];
    locationBtn.titleLabel.font = FONT(14);
    [locationBtn setTitleColor:Orange_COLOR forState:UIControlStateNormal];
    [locationBtn setTitle: NSLocalizedString(@"查看位置", NSStringFromClass([self class])) forState:UIControlStateNormal];
    locationBtn.userInteractionEnabled = YES;
    [locationBtn addTarget:self action:@selector(clickLocation) forControlEvents:UIControlEventTouchUpInside];
    self.locationBtn = locationBtn;
    
    UIView *lineView=[UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset=0;
        make.bottom.offset=-1;
        make.right.offset=0;
        make.height.offset=1;
    }];
    lineView.backgroundColor=LINE_COLOR;
}

#pragma mark ====== Functions =======
-(void)clickLocation{
    YF_SAFE_BLOCK(self.clickLocationBlock,NO,@"");
}

-(void)clickShop{
    YF_SAFE_BLOCK(self.clickShopBlock,NO,self.shop_id);
}

-(void)reloadViewWithModel:(JHWaiMaiModel *)model{
    _shop_id = model.shop_id;
    [self.titleBtn setTitle:model.shop_title forState:UIControlStateNormal];
    
    if (self.is_detail) {
        self.statusLab.hidden = YES;
        self.locationBtn.hidden = ![model.pei_type isEqualToString:@"3"];
    }else{
        self.statusLab.hidden = NO;
        self.locationBtn.hidden = YES;
        self.statusLab.text = model.order_status_label;
    }
    
    
}

@end
