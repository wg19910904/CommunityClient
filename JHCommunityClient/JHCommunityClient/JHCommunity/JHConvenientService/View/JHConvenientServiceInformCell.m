//
//  JHConvenientServiceInformCell.m
//  JHCommunityClient
//
//  Created by jianghu2 on 16/8/6.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHConvenientServiceInformCell.h"
#import <Masonry/Masonry.h>
@implementation JHConvenientServiceInformCell
{
   
    
    UILabel *_bottomLine;//底部边线
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark--===初始化子控件
- (void)initSubViews{
    _selectedImg = [UIImageView new];
    _selectedImg.image = IMAGE(@"Check_no");
    [self.contentView addSubview:_selectedImg];
    [_selectedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    _title = [UILabel new];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    _title.text = NSLocalizedString(@"举报理由", nil);
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectedImg.mas_right).offset = 15;
        make.centerY.equalTo(self.contentView);
        make.right.offset = -15;
        make.height.offset = 14;
    }];
    _bottomLine = [UILabel new];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.size.mas_equalTo(CGSizeMake(WIDTH, 0.5));
        make.bottom.offset = 0;
    }];
    _bottomLine.backgroundColor = LINE_COLOR;
}
@end
