//
//  JHPayFeeCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/9.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPayFeeCell.h"

@implementation JHPayFeeCell
{
    UIView *_bottomLine;//底部边线
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
#pragma mark-===初始化子控件
- (void)initSubViews{
    _iconImg = [UIImageView new];
    [self.contentView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 15;
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImg.mas_right).offset = 15;
        make.centerY.equalTo(self.contentView);
        make.right.offset = -45;
        make.height.offset = 16;
    }];
    
    _selectImg = [UIImageView new];
    [self.contentView addSubview:_selectImg];
    [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -15;
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.contentView);
    }];
    _selectImg.image = IMAGE(@"Check_no");
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0:
        {
            _iconImg.image = IMAGE(@"pay_2");
            _title.text = NSLocalizedString(@"支付宝支付", nil);
        }
            break;
        case 1:
        {
            _iconImg.image = IMAGE(@"pay_3");
            _title.text = NSLocalizedString(@"微信支付", nil);
        }
            break;
        case 2:
        {
            _iconImg.image = IMAGE(@"pay_4");
            _title.text = NSLocalizedString(@"余额支付", nil);
        }
            break;
        default:
            break;
    }
}
@end
