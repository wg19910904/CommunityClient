//
//  JHMaidanOrderDetailShopNameCell.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderDetailShopNameCell.h"

@implementation JHMaidanOrderDetailShopNameCell
{
    UILabel *_shopTitle;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    //图片
    UIImageView *shopIV = [UIImageView new];
    [self addSubview:shopIV];
    [shopIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.width.height.offset = 10;
        make.centerY.offset = 0;
    }];
    shopIV.image = IMAGE(@"maidanshop");
    
    //店铺名称
    _shopTitle = [UILabel new];
    [self addSubview:_shopTitle];
    [_shopTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 40;
        make.top.bottom.offset = 0;
        make.width.offset = 200;
        make.height.offset = 45;
    }];
    _shopTitle.textColor = HEX(@"333333", 1.0);
    _shopTitle.font = FONT(14);
    
    //添加分隔线
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset = 0;
        make.height.offset = 0.5;
    }];
    lineView.backgroundColor = LINE_COLOR;
}

-(void)setCellModel:(JHMaiDanModel *)cellModel{
    _shopTitle.text = cellModel.shop_title;
}

@end
