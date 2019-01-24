//
//  JHMaidanOrderDetailStatusCell.m
//  JHCommunityClient
//
//  Created by xixixi on 2018/5/21.
//  Copyright © 2018年 JiangHu. All rights reserved.
//

#import "JHMaidanOrderDetailStatusCell.h"

@implementation JHMaidanOrderDetailStatusCell
{
    UIImageView *_imgIV; //支付成功的图片
    UILabel *_successL;  //支付成功的状态
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = THEME_COLOR;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //支付成功的图片
    _imgIV = [UIImageView new];
    [self addSubview:_imgIV];
    [_imgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 20;
        make.width.height.offset = 20;
        make.centerY.offset = 0;
    }];
    
    //支付成功的状态
    _successL = [UILabel new];
    [self addSubview:_successL];
    [_successL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgIV.mas_right).offset = 15;
        make.height.offset = 45;
        make.width.offset = 200;
        make.top.bottom.offset = 0;
    }];
    _successL.textColor = HEX(@"ffffff", 1.0);
    _successL.font = [UIFont boldSystemFontOfSize:17];
}

-(void)setCellModel:(JHMaiDanModel *)cellModel{
    _imgIV.image = IMAGE(@"order_success");
    _successL.text = NSLocalizedString(@"支付成功", nil);
}

@end
