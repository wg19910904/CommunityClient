//
//  JHHistoryCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/30.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHHistoryCell.h"

@implementation JHHistoryCell
{
    UIImageView *_leftIV;
    UILabel *_titleLabel;
    UIButton *_rightBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加控件
        [self createSubView];
        self.frame = FRAME(0, 0, WIDTH, 45);
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}
#pragma mark - 添加控件
- (void)createSubView
{
    _leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 15, 15, 15)];
    _leftIV.image = IMAGE(@"time");
    
    _titleLabel = [[UILabel alloc] initWithFrame:FRAME(30, 0, WIDTH - 60, 45)];
    _titleLabel.font = FONT(16);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    
    _rightBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 50, 2.5,40,40)];
    [_rightBtn setImage:IMAGE(@"closeNew") forState:(UIControlStateNormal)];
    [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    
    [self addSubview:_leftIV];
    [self addSubview:_titleLabel];
    [self addSubview:_rightBtn];
}
@end
