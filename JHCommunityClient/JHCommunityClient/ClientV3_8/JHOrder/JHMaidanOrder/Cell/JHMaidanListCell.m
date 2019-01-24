//
//  JHMaidanListCell.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/19.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanListCell.h"
#import <UIImageView+WebCache.h>
#import "NSString+Tool.h"

@implementation JHMaidanListCell
{
    UIImageView *_imgIV; //图片
    UILabel *_titleL; //店名
    UILabel *_statusL; //当前状态
    UILabel *_costPriceL; //消费金额
    UILabel *_finalPriceL; //实付金额
    UIButton *_actionBtn; //点击事件
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    //img
    _imgIV = [UIImageView new];
    [self addSubview:_imgIV];
    [_imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset = 15;
        make.bottom.offset = -15;
        make.width.height.offset = 80;
    }];
    _imgIV.clipsToBounds = YES;
    _imgIV.contentMode = UIViewContentModeScaleAspectFill;
    
    //titleL
    _titleL = [UILabel new];
    [self addSubview:_titleL];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgIV.mas_right).offset = 15;
        make.top.offset = 16;
        make.height.offset = 22;
        make.right.offset(-60);
    }];
    _titleL.numberOfLines = NSLineBreakByTruncatingTail;
    _titleL.textColor = HEX(@"333333", 1.0);
    _titleL.font = FONT(16);
    
    //_stausL
    _statusL = [UILabel new];
    [self addSubview:_statusL];
    [_statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.top.offset = 16;
        make.height.offset = 20;
    }];
    _statusL.textColor = THEME_COLOR;
    _statusL.textAlignment = NSTextAlignmentRight;
    _statusL.font = FONT(14);
    
    //costpriceL
    _costPriceL = [UILabel new];
    [self addSubview:_costPriceL];
    [_costPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom).offset = 6;
        make.height.offset = 20;
    }];
    _costPriceL.textColor = HEX(@"737373", 1.0);
    _costPriceL.font = FONT(14);
    
    //finalPriceL
    _finalPriceL = [UILabel new];
    [self addSubview:_finalPriceL];
    [_finalPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.top.equalTo(_costPriceL.mas_bottom).offset = 12;
        make.height.offset = 20;
    }];
    _finalPriceL.textColor = TEXT_COLOR;
    _finalPriceL.font = FONT(14);
    
    //actionBtn
    _actionBtn = [UIButton new];
    [self addSubview:_actionBtn];
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.bottom.offset = -15;
        make.height.offset = 24;
        make.width.offset = 64;
    }];
    [_actionBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_actionBtn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
    _actionBtn.titleLabel.font = FONT(14);
    _actionBtn.layer.borderWidth = 0.5;
    _actionBtn.layer.borderColor = THEME_COLOR.CGColor;
    _actionBtn.layer.cornerRadius = 2;
    _actionBtn.clipsToBounds = YES;
    [_actionBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickBtn{
    YF_SAFE_BLOCK(self.clickComment,NO,@"");
}

- (void)setCellModel:(JHMaiDanModel *)model{
    [_imgIV sd_setImageWithURL:ImageUrl(model.shop_logo) placeholderImage:DefaultImgViewImage];
    _titleL.text = model.shop_title;
    _statusL.text = model.order_status_label;
    _costPriceL.text = [NSString stringWithFormat: NSLocalizedString(@"消费: ¥ %@", NSStringFromClass([self class])),model.total_price];
    
    NSString *str = [NSString stringWithFormat: NSLocalizedString(@"¥ %@", nil),model.real_pay];
    NSString *price_str = [NSString stringWithFormat: NSLocalizedString(@"实付: %@", nil),str];
    
    _finalPriceL.attributedText = [NSString getAttributeString:price_str dealStr:str strAttributeDic:@{NSForegroundColorAttributeName:HEX(@"ff0000", 1.0)}];
    NSDictionary *dic = [model.order_button firstObject];
    [_actionBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
    
}

@end
