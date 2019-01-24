//
//  JHIntegrationDropListCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/29.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHIntegrationDropListCell.h"
#import "UIImageView+NetStatus.h"
@implementation JHIntegrationDropListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark--===初始化子控件
- (void)initSubViews{
    _iconImg = [UIImageView new];
    _iconImg.layer.cornerRadius = 10.0f;
    _iconImg.clipsToBounds = YES;
    [self.contentView addSubview:_iconImg];
    [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 10;
        make.bottom.offset = -10;
        make.width.offset = 20;
    }];
    
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.text = NSLocalizedString(@"新品推荐", nil);
    _title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.offset = -27;
        make.centerY.equalTo(self.contentView);
    }];
    _selectImg = [UIImageView new];
    [self.contentView addSubview:_selectImg];
    _selectImg.image = IMAGE(@"selected-0");
    _selectImg.hidden = YES;
    [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -10;
        make.size.mas_equalTo(CGSizeMake(12, 10));
        make.centerY.equalTo(self.contentView);
    }];
    UIView *topLine = [UIView new];
    topLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.offset = 0.5;
    }];
}
- (void)setModel:(IntegrationMallCateBntModel *)model{
    _model = model;
    if(model.icon.length == 0 || model.icon == nil){
        _iconImg.image = IMAGE(@"icon_more");
    }else{
         [_iconImg sd_image:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:model.icon]] plimage:IMAGE(@"jfcategory")];
    }
   
    _title.text = model.title;
}
@end
